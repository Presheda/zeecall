import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zeecall/features/call/export_call.dart';
import 'package:zeecall/features/model/agora_user.dart';
import 'package:zeecall/presentation/widgets/control_section.dart';
import 'package:zeecall/presentation/widgets/grid_item.dart';
import 'package:zeecall/presentation/widgets/widget_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OngoingCallScreen extends StatefulWidget {
  const OngoingCallScreen({Key? key}) : super(key: key);

  @override
  State<OngoingCallScreen> createState() => _OngoingCallScreenState();
}

class _OngoingCallScreenState extends State<OngoingCallScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => endCall(),
      child: BlocBuilder<CallBloc, CallState>(buildWhen: (state, s) {
        return s.callInformation!.callStatus == CallStatus.joinedCall;
      }, builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                "Zee Calls",
                style: GoogleFonts.bangers(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: const Color(0xff141414)),
              ),
              toolbarHeight: 100,
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridItem(),
            ),
            bottomNavigationBar: ControlSection(
              endCall : (){
                endCall();
              },
                user: context.read<CallBloc>().state.users!.firstWhere(
                    (element) => element.localUser = true,
                    orElse: () => AgoraUser(
                        userId: 0,
                        videoEnabled: true,
                        phoneSpeakerEnabled: true,
                        voiceEnabled: true))));
      }),
    );
  }

  Future<bool> endCall() async {
    bool cancelCall = false;

    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c) {
          return BlocProvider.value(
            value: context.read<CallBloc>(),
            child: StatefulBuilder(builder: (context, setState) {
              return BlocListener<CallBloc, CallState>(
                  listenWhen: (p, pp) =>
                      pp.callInformation!.callStatus == CallStatus.leftCall,
                  listener: (s, st) {
                    if (st.callInformation!.callStatus == CallStatus.leftCall) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: AlertDialog(
                    title: CustomText(
                      title: cancelCall ? "Please wait" : "End Call ? ",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    content: cancelCall
                        ? Container(
                      height: 50,
                            child: Center(child: const CircularProgressIndicator()))
                        : CustomText(
                            title: "The call will be terminated",
                      fontSize: 14,
                          ),
                    actions: cancelCall
                        ? []
                        : [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  cancelCall = true;
                                });
                                context.read<CallBloc>().add(ToggleControlButton(
                                    button: ControlButton.endCall));
                              },
                              child: CustomText(
                                title: "Yes",
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: CustomText(
                                title: "No",
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            )
                          ],
                  ));
            }),
          );
        });

    if (cancelCall) {}

    return cancelCall;
  }
}

List<Color> multiColors = [
  Colors.red,
  Colors.amber,
  const Color(0xff34C47C),
  Colors.cyan,
  Colors.deepPurple,
  Colors.purpleAccent,
  Colors.blue,
];
