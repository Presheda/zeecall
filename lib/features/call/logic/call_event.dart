import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:zeecall/features/call/export_call.dart';
import 'package:zeecall/features/model/agora_user.dart';

abstract class CallEvent extends Equatable {}

class CallEventNameSubmitted extends CallEvent {
  late String name;

  CallEventNameSubmitted(this.name);

  @override
  List<Object?> get props => [name];
}

class CallEventFilterUsers extends CallEvent {
  @override
  List<Object?> get props => [];
}

/// this event is fired when a user pasted a link [FirebaseDynamicLinks] or pasted a [Link]
class JoinFromLink extends CallEvent {
  @override
  List<Object?> get props => [];
}

/// this event is used when a user generated a link on the app
class StartNewCallClicked extends CallEvent {
  @override
  List<Object?> get props => [];
}

class RemoteUserJoined extends CallEvent {
  late CallState state;
  RemoteUserJoined({required this.state});

  @override
  List<Object?> get props => [state];
}

class LocalUserJoined extends CallEvent {
  late CallState state;
  LocalUserJoined({required this.state});

  @override
  List<Object?> get props => [state];
}

class LocalUserLeft extends CallEvent {
  late CallState state;
  late AgoraUser user;
  LocalUserLeft({required this.state, required this.user});

  @override
  List<Object?> get props => [state];
}

class RemoteUserLeft extends CallEvent {
  late CallState state;
  RemoteUserLeft({required this.state});

  @override
  List<Object?> get props => [state];
}

class UpdateDatabaseEvent extends CallEvent {
  late CallState state;
  UpdateDatabaseEvent({required this.state});

  @override
  List<Object?> get props => [state];
}

class ResetChannelAndToken extends CallEvent {
  @override
  List<Object?> get props => [];
}

enum ControlButton { microphone, video, phoneSpeaker, endCall }

class ToggleControlButton extends CallEvent {
  late ControlButton button;

  ToggleControlButton({required this.button});

  @override
  List<Object?> get props => [];
}
