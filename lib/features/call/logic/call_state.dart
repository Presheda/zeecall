import 'package:equatable/equatable.dart';
import 'package:zeecall/features/model/agora_user.dart';

/// This is the initial call state
/// This are all the required parameters need to join a channel
/// we are going to be validating each parameters as different [CallInitial] are create
///

enum CallStatus {
  collectingInformation,
  generatingLink,
  generatingLinkFailed,
  generatingLinkSuccess,
  joinedCall,
  leftCall
}

class CallInformation extends Equatable {
  CallInformation(
      {this.name,
      this.channelName,
      this.channelToken,
      this.callStatus = CallStatus.collectingInformation})
      : lastUpdated = DateTime.now();

  String? name;
  String? channelName;
  String? channelToken;
  late CallStatus? callStatus;

  final DateTime lastUpdated;

  CallInformation copyWith(
      {String? name,
      String? channelName,
      String? channelToken,
      CallStatus? callStatus,
      bool? joinedChannel}) {
    return CallInformation(
      name: name ?? this.name,
      channelName: channelName ?? this.channelName,
      channelToken: channelToken ?? this.channelToken,
      callStatus: callStatus ?? this.callStatus,
    );
  }

  @override
  List<Object?> get props =>
      [name, channelName, channelToken, lastUpdated, callStatus];
}

class CallState extends Equatable {
  late CallInformation? callInformation;

  final List<AgoraUser>? users;

  late bool fromLink;

  String? host;

  String? callLink;

  CallState({
    this.callInformation,
    this.users = const [],
    this.host,
    this.fromLink = false,
    this.callLink,
  });

  CallState.InitialState()
      : callInformation = CallInformation(),
        users = [],
        fromLink = false;

  CallState copyWith(
      {CallInformation? callInformation,
      List<AgoraUser>? users,
      bool? fromLink,
      String? host,
      String? callLink}) {
    return CallState(
        callInformation: callInformation ?? this.callInformation,
        fromLink: fromLink ?? this.fromLink,
        host: host ?? this.host,
        callLink: callLink ?? this.callLink,
        users: users == null ? this.users : List.of(users));
  }

  @override
  List<Object?> get props => [callInformation, users, fromLink, host, callLink];
}
