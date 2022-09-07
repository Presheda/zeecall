import 'package:zeecall/presentation/presentation_export.dart';
import 'package:zeecall/features/splashscreen/spalsh_export.dart';

class AppRouter {
  static const String splashScreen = "/";
  static const String profileScreen = "/profileScreen";
  static const String callScreen = "/callScreen";

  Route onGenerateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());

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
}
