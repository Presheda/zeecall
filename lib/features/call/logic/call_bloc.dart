import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zeecall/features/call/logic/call_event.dart';
import 'package:zeecall/features/call/logic/call_state.dart';
import 'package:zeecall/features/call/repository/agora_user_repository.dart';
import 'package:zeecall/features/call/repository/cloud_functions.dart';
import 'package:zeecall/features/model/agora_user.dart';
import 'package:zeecall/presentation/utils/logger.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  late CallInformation? callInformation;
  bool enable = true;

  late RtcEngine engine;

  AgoraUserRepository? userRepository;

  CloudFunctionsRepository cloudFunctionsRepository;

  StreamSubscription<List<AgoraUser>>? streamSubscription;

  List<AgoraUser> databaseUsers = [];

  Uri? link;

  CallBloc({
    this.cloudFunctionsRepository = const CloudFunctionsRepository(),
    this.userRepository,
    this.link,
  }) : super(CallState.InitialState()) {
    userRepository ??= AgoraUserRepository();
    callInformation = state.callInformation;

    checkForDynamicLink();

    on<CallEventNameSubmitted>((event, emit) => nameSubmitted(event, emit));

    on<JoinFromLink>((event, emit) => joinFromLink(event, emit));

    on<StartNewCallClicked>((event, emit) => startNewCall(event, emit));
    on<ResetChannelAndToken>(
        (event, emit) => resetChannelAndToken(event, emit));

    on<ToggleControlButton>((event, emit) => toggleControlButton(event, emit));

    on<RemoteUserJoined>(
        (event, emit) => remoteUserJoinStateEvent(event, emit));

    on<LocalUserJoined>((event, emit) => localUserJoinStateEvent(event, emit));

    on<UpdateDatabaseEvent>((event, emit) => updateDatabaseEvent(event, emit));

    on<RemoteUserLeft>((event, emit) => remoteUserLeftEvent(event, emit));

    on<LocalUserLeft>((event, emit) => localUserLeft(event, emit));
  }

  void remoteUserJoinStateEvent(
      RemoteUserJoined event, Emitter<CallState> emit) {
    emit(event.state);
  }

  void localUserJoinStateEvent(LocalUserJoined event, Emitter<CallState> emit) {
    emit(event.state);
  }

  void updateDatabaseEvent(UpdateDatabaseEvent event, Emitter<CallState> emit) {
    emit(event.state);
  }

  void localUserLeft(LocalUserLeft event, Emitter<CallState> emit) async {
    emit(event.state);

    userRepository!.deleteLocalUser(
        user: event.user,
        channelName: state.callInformation!.channelName ?? "");

    //  await Future.delayed(Duration(milliseconds: 500));
  }

  void remoteUserLeftEvent(RemoteUserLeft event, Emitter<CallState> emit) {
    emit(event.state);
  }

  void resetChannelAndToken(
      ResetChannelAndToken event, Emitter<CallState> emit) {
    emit(CallState.InitialState());
  }

  /// toggle button, it take the  event which contains the button type that was pressed
  toggleControlButton(
      ToggleControlButton event, Emitter<CallState> emit) async {
    ControlButton selectedButton = event.button;

    /// the end call was pressed, we leave the channel and emit a state
    if (selectedButton == ControlButton.endCall) {
      await engine.destroy();

      localLeaveChannel();

      callInformation =
          state.callInformation!.copyWith(callStatus: CallStatus.leftCall);
      emit(state.copyWith(callInformation: callInformation));

      return;
    }

    List<AgoraUser>? users = state.users!;

    AgoraUser user = users.firstWhere((element) => element.localUser);

    if (selectedButton == ControlButton.video) {
      user.videoEnabled = !user.videoEnabled;
      engine.enableLocalVideo(user.videoEnabled);
    }
    if (selectedButton == ControlButton.microphone) {
      user.voiceEnabled = !user.voiceEnabled;
      engine.enableLocalAudio(user.voiceEnabled);
    }

    if (selectedButton == ControlButton.phoneSpeaker) {
      user.phoneSpeakerEnabled = !user.phoneSpeakerEnabled;

      engine.setEnableSpeakerphone(user.phoneSpeakerEnabled);
    }

    int index = users.indexWhere((element) => element.localUser);

    users.insert(index, user);

    users.removeAt(index + 1);

    emit(state.copyWith(
        users: users,
        callInformation:
            callInformation!.copyWith(callStatus: CallStatus.joinedCall)));
  }

  nameSubmitted(CallEventNameSubmitted event, Emitter<CallState> emit) {
    callInformation = callInformation!.copyWith(
        name: event.name, callStatus: CallStatus.collectingInformation);

    emit(state.copyWith(
      callInformation: callInformation,
    ));
  }

  joinFromLink(JoinFromLink event, Emitter<CallState> emit) async {
    /// no validation for now, we are going to assume it's valid
    String channelName = state.callInformation!.channelName ?? "";

    /// since we have the channel name, let's attempt joining a call with that channel name
    /// while doing that we need to emit a new state and dis

    callInformation = callInformation!.copyWith(
        channelName: channelName, callStatus: CallStatus.generatingLink);

    emit(state.copyWith(
      callInformation: callInformation,
    ));

    try {
      // call the repo and attempt to join
      var result = await cloudFunctionsRepository.callFunction(
          name: "generateToken",
          data: {"documentId": channelName, "channelName": channelName});

      if (result == -1) {
        /// success

        callInformation = callInformation!.copyWith(
            channelName: channelName,
            callStatus: CallStatus.generatingLinkFailed);

        emit(state.copyWith(
          callInformation: callInformation,
        ));
      }

      /// success

      callInformation = callInformation!.copyWith(
          channelName: channelName,
          channelToken: result,
          callStatus: CallStatus.generatingLinkSuccess);

      emit(state.copyWith(
        callInformation: callInformation,
      ));

      joinChannelZeeCall();
    } catch (_) {}
  }

  startNewCall(StartNewCallClicked event, Emitter<CallState> emit) async {
    String id = FirebaseFirestore.instance.collection("general").doc().id;

    var data = {
      "channelName": id,
      "documentId": id,
      "callerName": callInformation!.name
    };

    callInformation = state.callInformation!
        .copyWith(channelName: id, callStatus: CallStatus.generatingLink);

    emit(state.copyWith(
      callInformation: callInformation,
    ));

    Uri? uri = await generateLink();

    try {
      // call the repo and attempt to join
      var result = await cloudFunctionsRepository.callFunction(
          name: "generateChannelName", data: data);

      if (result == -1) {
        /// succes

        callInformation = callInformation!.copyWith(
            channelName: id, callStatus: CallStatus.generatingLinkFailed);

        emit(state.copyWith(
          callInformation: callInformation,
        ));
      }

      /// success

      callInformation = callInformation!.copyWith(
          channelToken: result, callStatus: CallStatus.generatingLinkSuccess);
      emit(state.copyWith(
        callLink: uri.toString(),
        callInformation: callInformation,
      ));

      /// let's attempt to join call

      joinChannelZeeCall();
    } catch (e) {
      callInformation = callInformation!
          .copyWith(callStatus: CallStatus.generatingLinkFailed);
      emit(state.copyWith(
        callInformation: callInformation,
      ));
    }
  }

  Future setupEngine() async {
    engine = await RtcEngine.createWithContext(
        RtcEngineContext("3c0953100b594c5fa26d6add191055c9"));

    registerAgoraEventHandler();

    return;
  }

  void registerAgoraEventHandler() async {
    engine.setEventHandler(RtcEngineEventHandler(
        localVideoStateChanged: localVideo,
       // lastmileQuality: localNetworkQuality,
        networkQuality: remoteNetworkQuality,
        streamMessageError: streamMessageError,

        remoteAudioStateChanged: remoteAudioStateChanged,
        localAudioStateChanged: localAudioStateChanged,
        remoteVideoStateChanged: remoteVideoStateChanged,
        error: onErrorOccurred,
        connectionLost: localConnectionLost,
        networkTypeChanged: localNetworkTypeChanged,
        connectionStateChanged: localConnectionStateChanged,
        rejoinChannelSuccess: localRejoinChannelSuccess,
        joinChannelSuccess: localUserJoined,
        userJoined: remoteUserJoined,
        userOffline: remoteUserOffline));
  }

  void joinChannelZeeCall() async {
    await setupEngine();

    await [Permission.microphone, Permission.camera].request();

    var media = ChannelMediaOptions(
      autoSubscribeAudio: true,
      publishLocalAudio: true,
      publishLocalVideo: true,
    );

    if (callInformation!.channelName == null) return;

    AppLogger.log("w", callInformation!.channelName ?? "");

    await engine.joinChannel(callInformation!.channelToken ?? "",
        callInformation!.channelName ?? "", null, 0, media);

    engine.enableAudio();

    engine.enableVideo();
    engine.enableLocalAudio(true);
    engine.setEnableSpeakerphone(true);

    await engine.setChannelProfile(ChannelProfile.Communication);

    engine.muteLocalAudioStream(false);
  }

  void localUserJoined(String channel, int uid, int elapsed) async {
    engine.setLocalVoicePitch(1);
    engine.adjustRecordingSignalVolume(400);
    engine.adjustPlaybackSignalVolume(400);

    callInformation =
        callInformation!.copyWith(callStatus: CallStatus.joinedCall);

    /// when we join the channel, we want to add it to the state first before emitting

    var user = AgoraUser(
        userId: uid,
        voiceEnabled: true,
        videoEnabled: true,
        name: state.callInformation!.name ?? "",
        localUser: true,
        phoneSpeakerEnabled: true);

    List<AgoraUser> users = List.of(state.users!);
    users.add(user);

   // users.add(user);
   // users.addAll(state.users!);

    AppLogger.log("d", "Join channel ");

    addToDatabase(user);
    CallState s = filterList(users: users);

    add(LocalUserJoined(state: s));
    subscribeToUsersInDatabase();
  }

  void addToDatabase(AgoraUser agoraUser) async {
    await userRepository!.saveUser(
        agoraUser: agoraUser,
        channelName: state.callInformation!.channelName ?? "");
  }

  void remoteUserOffline(int uid, UserOfflineReason reason) async {
    List<AgoraUser> users = List.of(state.users!);

    users.removeWhere((element) => element.userId == uid);

    add(RemoteUserLeft(state: filterList(users: users)));
  }

  void remoteUserJoined(int uid, int elapsed) async {
    if (state.users!.length >= 4) {
      AppLogger.log("w", "User length is greater then four");
      return;
    }

    var user = AgoraUser(
        userId: uid,
        voiceEnabled: true,
        videoEnabled: true,
        localUser: false,
        phoneSpeakerEnabled: true);

    List<AgoraUser> users = List.of(state.users!)..add(user);

    AppLogger.log("w", "State data $state");

    CallState s = filterList(users: users);

    add(RemoteUserJoined(state: s));
  }

  void localRejoinChannelSuccess(String channel, int uid, int elapsed) {}

  void localLeaveChannel() async {
    AppLogger.log(
        "w", "Local User has now left the channel, attempting joining");

    List<AgoraUser> users = List.of(state.users!);

    int index = users.indexWhere((element) => element.localUser == true);

    if (index == -1) return;

    AgoraUser user = users[index];

    users.removeWhere((element) => element.localUser == true);

    /// when a local user leaves the channel, we also want to delete it from
    /// the database

    add(LocalUserLeft(state: filterList(users: users), user: user));
  }

  void localConnectionStateChanged(
      ConnectionStateType state, ConnectionChangedReason reason) {
    AppLogger.log("d","localConnectionStateChanged() called");
  }

  void localNetworkTypeChanged(NetworkType type) {
    AppLogger.log("d","localNetworkTypeChanged() called");
  }

  void localConnectionLost() {}

  void remoteAudioStateChanged(int uid, AudioRemoteState state,
      AudioRemoteStateReason reason, int elapsed) {
    AppLogger.log("d","remoteAudioStateChanged() called");
  }

  void localAudioStateChanged(AudioLocalState state, AudioLocalError error) {
    AppLogger.log("d","localAudioStateChanged() called");
  }


  void streamMessageError(
      int uid, int streamId, ErrorCode error, int missed, int cached) {}

  void streamMessage(int uid, int streamId, String data) {}

  void remoteNetworkQuality(
      int uid, NetworkQuality txQuality, NetworkQuality rxQuality) {}

  // void localNetworkQuality(NetworkQuality quality) {
  //   String networkMessage = "Detecting..";
  //
  //   switch (quality) {
  //     case NetworkQuality.Unknown:
  //       networkMessage = "Detecting...";
  //       break;
  //     case NetworkQuality.Excellent:
  //       networkMessage = "Excellent";
  //       break;
  //     case NetworkQuality.Good:
  //       networkMessage = "Good";
  //       break;
  //     case NetworkQuality.Poor:
  //       networkMessage = "Poor";
  //       break;
  //     case NetworkQuality.Bad:
  //       networkMessage = "Bad";
  //       break;
  //     default:
  //       networkMessage = "Bad";
  //   }
  // }

  void onErrorOccurred(ErrorCode code) async {
    AppLogger.log("d","Error occurred $code");

    String message = "Error occurred ";

   bool end  = false;

    /// an error occurred that we most likely want to handle ourselves

    switch (code) {
      case ErrorCode.NoPermission:
        message = "No permission granted";
        end = true;
        break;

      case ErrorCode.Abort:
        end = true;
        break;

      case ErrorCode.AdmGeneralError:
        message = "No permission granted";
        end = true;
        break;

      case ErrorCode.AdmInitLoopback:
        message = "Error occurred";
        end = true;
        break;

      case ErrorCode.ResourceLimited:
        message = "Error occurred";
        end = true;
        break;

      case ErrorCode.InvalidAppId:
        message = "Error occurred";
        end = true;
        break;

      case ErrorCode.InvalidChannelId:
        message = "Error occurred";
        end = true;
        break;

      case ErrorCode.AdmJavaResource:
        message = "Error occurred";
        end = true;
        break;

      case ErrorCode.LeaveChannelRejected:
        message = "Error occurred";
        end = true;
        break;

      default:

        /// something happened, our best solution is to alert the user and leave the screen
        break;
    }

    AppLogger.log("d", "$message  :: $end" );
  }

  void localVideo(LocalVideoStreamState localVideoState,
      LocalVideoStreamError error) async {}

  void remoteVideoStateChanged(int uid, VideoRemoteState state,
      VideoRemoteStateReason reason, int elapsed) {
    List<AgoraUser> users = [...this.state.users!];

    int index = users.indexWhere((element) => element.userId == uid);

    AgoraUser user = users[index];

    if (state != VideoRemoteState.Starting ||
        state != VideoRemoteState.Decoding) {
      /// we assume the user video state is off
      user.videoEnabled = false;
    }

    users.insert(index, user);

    users.removeAt(index + 1);

    emit(this.state.copyWith(users: users));
  }

  @override
  Future<void> close() {
    streamSubscription!.cancel();
    return super.close();
  }

  ///
  CallState filterList({List<AgoraUser>? users}) {
    /// this is the list from that database collection
    /// we don't know how many is still in still in the channel
    /// so we want to filter it to only those in the channel

    /// create a copy of the current users in the channel in the state

    users ??= List.of(state.users!);
    // List<AgoraUser> channelUsers = List.of(state.users!);

    /// we loop through them
    users.forEach((element1) {
      AgoraUser? u;

      /// we are trying to find [element1] in the list of collection
      /// that was just return from the database
      try {
        u = databaseUsers.firstWhere(
          (element) => element1.userId == element.userId,
        );
      } catch (_) {}

      /// this is just us trying to get the index of [element1] to enable us manipulate it later
      int index =
          users!.indexWhere((element2) => element2.userId == element1.userId);

      /// if u is not null that means indeed element1 which is in the database is still in the channel
      /// so we just take the name and update it in the list
      if (u != null) {
        users[index].name = u.name;
      }

      /// repeat the process
    });

    /// by now we would have updated all the names of the users in the channel that are in the database
    ///  we can now emit a new  state

    AppLogger.log("w", "MOre Filter List Called()");

    var s = state.copyWith(users: users, callInformation: callInformation);

    // emit(s);

    return s;
  }

  void subscribeToUsersInDatabase() {
    streamSubscription?.cancel();
    streamSubscription = userRepository!
        .fetchUsers(channelName: state.callInformation!.channelName ?? "")
        .listen((event) {
      databaseUsers = event;

      CallState s = filterList();

      add(UpdateDatabaseEvent(state: s));
    });
  }

  Future generateLink() async {
    String host = "zeecall.page.link";

    String imageLink =
        "https://images.pexels.com/photos/9322926/pexels-photo-9322926.jpeg?auto=compress&cs=tinysrgb&w=1600";

    Uri uri =
        Uri(scheme: "https", host: host, path: "/call/", queryParameters: {
      "channelName": state.callInformation!.channelName,
      "callHost": state.callInformation!.name,
    });

    final dynamicLinkParams = DynamicLinkParameters(
        link: uri,
        uriPrefix: "https://zeecall.page.link",
        androidParameters:
            const AndroidParameters(packageName: "com.zee.call.zeecall"),
        iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
        socialMetaTagParameters: SocialMetaTagParameters(
          description:
              "${state.callInformation!.name} has created a call link, you can join the call with this link",
          title: "ZeeCall link has been created",
          imageUrl: Uri.parse(imageLink),
        ));

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    print(dynamicLink.previewLink);
    print(dynamicLink.shortUrl);

    return dynamicLink.shortUrl;
  }

  void checkForDynamicLink() {
    if (link == null) return;

    String host = "zeecall.page.link";

    if (link!.host.toLowerCase() != host) return;
    String channelName = link!.queryParameters["channelName"]!;
    String callHost = link!.queryParameters["callHost"]!;

    AppLogger.log("w", channelName);

    callInformation = state.callInformation!.copyWith(channelName: channelName);

    emit(state.copyWith(
        fromLink: true,
        host: callHost,
        callLink: link.toString(),
        callInformation:
            state.callInformation!.copyWith(channelName: channelName)));
  }
}
