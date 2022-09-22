import 'package:flow_builder/flow_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zeecall/features/call/screen/ongoing_call_screen.dart';
import 'package:zeecall/presentation/widgets/widget_export.dart';
import 'package:zeecall/features/call/export_call.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallCredentialFlow extends StatefulWidget {
  const CallCredentialFlow({Key? key}) : super(key: key);

  @override
  State<CallCredentialFlow> createState() => _CallCredentialFlowState();
}

class _CallCredentialFlowState extends State<CallCredentialFlow> {
  late FlowController<CallInformation> flowController;

  @override
  void initState() {
    flowController = FlowController(CallInformation());

    flowController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallBloc, CallState>(builder: (context, state) {
      return FlowBuilder<CallInformation>(
          state: context.read<CallBloc>().state.callInformation,
          onGeneratePages: (state, pages) {
            return [
              const MaterialPage(child: CallScreenName()),
              if (state.name != null && state.name!.isNotEmpty)
                const MaterialPage(child: CallScreenChannel()),
              if (context.read<CallBloc>().state.callInformation!.callStatus ==
                  CallStatus.joinedCall)
                const MaterialPage(child: OngoingCallScreen())
            ];
          });
    });
  }
}

class CallScreenName extends StatefulWidget {
  const CallScreenName({Key? key}) : super(key: key);

  @override
  State<CallScreenName> createState() => _CallScreenNameState();
}

class _CallScreenNameState extends State<CallScreenName> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            "Zee Calls",
            style: GoogleFonts.bangers(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: const Color(0xff141414)),
          ),
          centerTitle: true,
          expandedHeight: 100,
          collapsedHeight: 100,
          pinned: false,
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
              delegate: SliverChildListDelegate(([
            const SizedBox(
              height: 14,
            ),
            Text(
              "Welcome to Zee Calls",
              style: GoogleFonts.bangers(
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: const Color(0xff141414)),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomText(
              title: "Let's get to know you, what's your name",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              maxLine: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: formKey,
                  child: CustomTextField(
                    hint: "Your name",
                    focus: focusNode,
                    controller: nameController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    maxLength: 15,
                    onChanged: (value) {
                      formKey.currentState!.validate();

                      if (!formKey.currentState!.mounted) return;

                      formKey.currentState!.validate();
                    },
                    validator: (name) {
                      return name != null && name.length >= 4
                          ? null
                          : "Invalid name";
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                  title: "Continue",
                  onTap: () {
                    if (!formKey.currentState!.mounted) return;

                    if (!formKey.currentState!.validate()) return;

                    focusNode.unfocus();

                    context.read<CallBloc>().add(
                        CallEventNameSubmitted(nameController.text.trim()));
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
          ]))),
        )
      ],
    ));
  }

  @override
  void dispose() {
    nameController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

class CallScreenChannel extends StatefulWidget {
  const CallScreenChannel({Key? key}) : super(key: key);

  @override
  State<CallScreenChannel> createState() => _CallScreenChannelState();
}

class _CallScreenChannelState extends State<CallScreenChannel> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            "Zee Calls",
            style: GoogleFonts.bangers(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: const Color(0xff141414)),
          ),
          centerTitle: true,
          expandedHeight: 100,
          collapsedHeight: 100,
          pinned: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: TextButton(
                  onPressed: ()=> context.read<CallBloc>().add(ResetChannelAndToken()),
                  child: CustomText(
                    title: "Reset",
                    fontSize: 15,
                    color: Colors.blue,
                  )),
            )
          ],
        ),
        Builder(builder: (cc) {
          return BlocListener<CallBloc, CallState>(
            listenWhen: (_, ss) =>
                ss.callInformation!.callStatus ==
                CallStatus.generatingLinkFailed,
            listener: (s, ss) {
              ScaffoldMessenger.of(cc)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).errorColor,
                    content: CustomText(
                      title: "Failed, Please try again",
                      color: Colors.white,
                      fontSize: 15,
                    )));
            },
            child: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                  delegate: SliverChildListDelegate(([
                const SizedBox(
                  height: 14,
                ),
                Text(
                  "Hello ${context.read<CallBloc>().state.callInformation!.name}",
                  style: GoogleFonts.bangers(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xff141414)),
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<CallBloc, CallState>(builder: (context, state) {
                  return CustomText(
                    title: state.fromLink
                        ? "${state.host} has invited you to a call, join or start a new call "
                        : "Create a call or join an existing one using a link",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    maxLine: 2,
                  );
                }),
                BlocBuilder<CallBloc, CallState>(builder: (context, state) {
                  nameController.text =
                      state.callInformation!.channelName ?? "";

                  if (state.callInformation!.callStatus ==
                      CallStatus.generatingLink) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomText(
                          title: "Please Wait",
                          fontSize: 20,
                          color: Colors.black,
                        )
                      ],
                    );
                  }

                  if (state.callInformation!.callStatus ==
                      CallStatus.generatingLinkSuccess) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomText(
                          title: "Joining Call",
                          fontSize: 20,
                          color: Colors.black,
                        )
                      ],
                    );
                  }

                  if (state.fromLink) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        CustomText(
                          title: state.callLink!,
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GradientButton(
                          title: "Continue Call",
                          onTap: () {
                            context.read<CallBloc>().add(JoinFromLink());
                          },
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: GradientButton(
                          title: "Start A New Call",
                          onTap: () {
                            context.read<CallBloc>().add(StartNewCallClicked());
                          },
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 60,
                ),
              ]))),
            ),
          );
        })
      ],
    ));
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
