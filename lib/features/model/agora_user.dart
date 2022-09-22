import 'package:equatable/equatable.dart';

class AgoraUser {
  late int userId;

  late bool videoEnabled;
  late bool voiceEnabled;

  late bool phoneSpeakerEnabled;

  late bool localUser;

  late String name;

  AgoraUser(
      {required this.userId,
      required this.videoEnabled,
      required this.phoneSpeakerEnabled,
      this.name = "User",
      this.localUser = true,
      required this.voiceEnabled});

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'videoEnabled': this.videoEnabled,
      'voiceEnabled': this.voiceEnabled,
      'phoneSpeakerEnabled': this.phoneSpeakerEnabled,
      'localUser': this.localUser,
      'name': this.name,
    };
  }

  factory AgoraUser.fromMap(Map<String, dynamic> map) {
    return AgoraUser(
      userId: map['userId'] as int,
      videoEnabled: map['videoEnabled'] as bool,
      voiceEnabled: map['voiceEnabled'] as bool,
      phoneSpeakerEnabled: map['phoneSpeakerEnabled'] as bool,
      localUser: map['localUser'] as bool,
      name: map['name'] as String,
    );
  }



  //
  // @override
  //
  // List<Object?> get props => [
  //       userId,
  //       videoEnabled,
  //       voiceEnabled,
  //       phoneSpeakerEnabled,
  //       localUser,
  //       name
  //     ];
}
