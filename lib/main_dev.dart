import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeecall/presentation/utils/observer.dart';
import 'firebase_options.dart';
import 'package:zeecall/presentation/presentation_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Bloc.observer = ZeeCallObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);

  // FirebaseAuth.instance.useAuthEmulator("localhost", 9099);

  String host = defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2:8080'
      : 'localhost:8080';

  FirebaseFirestore.instance.settings = Settings(host: host, sslEnabled: false);

  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(MyApp(link: initialLink?.link));
}

class MyApp extends StatefulWidget {
  Uri? link;

  MyApp({Key? key, required this.link}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter router;

  @override
  void initState() {
    router = AppRouter(link: widget.link);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zee Call',
      initialRoute: AppRouter.splashScreen,
      onGenerateRoute: router.onGenerateRoutes,
      theme: ZeeCallLightTheme.appLightTheme(),
    );
  }

  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }
}
