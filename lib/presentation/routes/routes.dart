import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeecall/presentation/presentation_export.dart';
import 'package:zeecall/features/splashscreen/spalsh_export.dart';
import 'package:zeecall/features/call/export_call.dart';

class AppRouter {
  Uri? link;

  CallBloc callBloc;

  AppRouter({this.link}) : callBloc = CallBloc(link:  link);

  static const String splashScreen = "/";
  static const String profileScreen = "/profileScreen";
  static const String callScreen = "/callScreen";

  Route onGenerateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: callBloc, child: const SplashScreen()));

      case callScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: callBloc, child: CallCredentialFlow()));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Container(
                    child: Center(
                      child: CustomText(
                        title: "No Routes",
                        fontSize: 18,
                      ),
                    ),
                  ),
                ));
    }
  }

  void dispose() {
    callBloc.close();
  }
}
