import 'dart:math';
import 'dart:ui';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zeecall/features/call/export_call.dart';
import 'package:zeecall/features/call/screen/ongoing_call_screen.dart';
import 'package:zeecall/features/model/agora_user.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeecall/presentation/utils/asset_names.dart';
import 'package:zeecall/presentation/utils/logger.dart';

import '../presentation_export.dart';

class GridItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallBloc, CallState>(
      builder: (context, state) {
        return StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: matchUserLayout(context));
      }
    );
  }

  List<Widget> matchUserLayout(BuildContext context) {
  late List<AgoraUser>  agoraUser = context.read<CallBloc>().state.users!;


  AppLogger.log("w", "Users in the list is ::::: ${agoraUser.length}");

    if (agoraUser.length == 4) return fourUsers(context: context);

    if (agoraUser.length == 3) return threeUsers(context: context);

    if (agoraUser.length == 2) return twoUsers(context: context);

    return oneUsers(context: context);
  }
}

class ZeeCallUserVideoWidget extends StatelessWidget {
  late AgoraUser user;

  late String image;

  ZeeCallUserVideoWidget({required this.user, required this.image});

  @override
  Widget build(BuildContext context) {

    Widget widget;

    if (user.videoEnabled) {
      if (user.localUser) {
        widget = RtcLocalView.SurfaceView(
          channelId:
              context.read<CallBloc>().state.callInformation!.channelName,
        );
      } else {
        widget = RtcRemoteView.SurfaceView(
          uid: user.userId,
          channelId:
              context.read<CallBloc>().state.callInformation!.channelName ?? "",
        );
      }
    } else {
      /// so here video is not enabled

      widget = Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor),
              child: CustomText(
                title: user.localUser ? "You" : user.name,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: widget,
    );
  }
}

List<Widget> fourUsers({required BuildContext context}) {
  List<AgoraUser> users = context.read<CallBloc>().state.users!;

  return [
    StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child:
          ZeeCallUserVideoWidget(user: users[0], image: AssetNames.pexelsOne),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 3,
      child:
          ZeeCallUserVideoWidget(user: users[1], image: AssetNames.pexelsTwo),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 3,
      child:
          ZeeCallUserVideoWidget(user: users[2], image: AssetNames.pexelsThree),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child:
          ZeeCallUserVideoWidget(user: users[3], image: AssetNames.pexelsFour),
    ),
  ];
}

List<Widget> threeUsers({required BuildContext context}) {
  List<AgoraUser> users = context.read<CallBloc>().state.users!;

  return [
    StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child:
          ZeeCallUserVideoWidget(user: users[0], image: AssetNames.pexelsOne),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child:
          ZeeCallUserVideoWidget(user: users[1], image: AssetNames.pexelsTwo),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 4,
      mainAxisCellCount: 3,
      child:
          ZeeCallUserVideoWidget(user: users[2], image: AssetNames.pexelsThree),
    ),
  ];
}

List<Widget> twoUsers({required BuildContext context}) {
  List<AgoraUser> users = context.read<CallBloc>().state.users!;

  return [
    StaggeredGridTile.count(
      crossAxisCellCount: 4,
      mainAxisCellCount: 3,
      child:
          ZeeCallUserVideoWidget(user: users[0], image: AssetNames.pexelsOne),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 4,
      mainAxisCellCount: 3,
      child:
          ZeeCallUserVideoWidget(user: users[1], image: AssetNames.pexelsTwo),
    ),
  ];
}

List<Widget> oneUsers({required BuildContext context}) {
  List<AgoraUser> users = context.read<CallBloc>().state.users!;
  return [
    StaggeredGridTile.count(
      crossAxisCellCount: 4,
      mainAxisCellCount: 3,
      child:
          ZeeCallUserVideoWidget(user: users[0], image: AssetNames.pexelsOne),
    ),
  ];
}
