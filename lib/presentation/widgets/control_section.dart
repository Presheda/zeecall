import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zeecall/features/call/export_call.dart';
import 'package:zeecall/features/model/agora_user.dart';
import 'package:zeecall/presentation/presentation_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlSection extends StatelessWidget {
  late AgoraUser user;

  Function() endCall;

  ControlSection({Key? key, required this.user, required this.endCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    title: context.read<CallBloc>().state.callLink.toString(),
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                              text: context
                                  .read<CallBloc>()
                                  .state
                                  .callLink
                                  .toString()))
                          .then((_) {



                        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                                content:
                                    Text('Link Copied to your clipboard !')));
                      });
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.copy,
                      size: 25,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          user.voiceEnabled
                              ? const Color(0xffF2F2F2)
                              : Theme.of(context).errorColor),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15))),
                  onPressed: () => context.read<CallBloc>().add(
                      ToggleControlButton(button: ControlButton.microphone)),
                  child: Icon(
                      user.voiceEnabled
                          ? FontAwesomeIcons.microphone
                          : FontAwesomeIcons.microphoneSlash,
                      size: 25,
                      color: user.voiceEnabled ? Colors.black : Colors.white)),
              const Expanded(
                  child: SizedBox(
                width: 1,
              )),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          user.videoEnabled
                              ? const Color(0xffF2F2F2)
                              : Theme.of(context).errorColor),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15))),
                  onPressed: () => context
                      .read<CallBloc>()
                      .add(ToggleControlButton(button: ControlButton.video)),
                  child: Icon(
                      user.videoEnabled
                          ? FontAwesomeIcons.video
                          : FontAwesomeIcons.videoSlash,
                      size: 25,
                      color: user.videoEnabled ? Colors.black : Colors.white)),
              const Expanded(
                  child: SizedBox(
                width: 1,
              )),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          user.phoneSpeakerEnabled
                              ? const Color(0xffF2F2F2)
                              : Theme.of(context).errorColor),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15))),
                  onPressed: () => context.read<CallBloc>().add(
                      ToggleControlButton(button: ControlButton.phoneSpeaker)),
                  child: Icon(
                      user.phoneSpeakerEnabled
                          ? FontAwesomeIcons.volumeHigh
                          : FontAwesomeIcons.volumeMute,
                      size: 25,
                      color: user.phoneSpeakerEnabled
                          ? Colors.black
                          : Colors.white)),
              const Expanded(
                  child: SizedBox(
                width: 1,
              )),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).errorColor),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15))),
                onPressed: endCall,
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.xmark,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      title: "End Call",
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
