// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const  FirebaseOptions android =  FirebaseOptions(
    apiKey: 'AIzaSyA2snuagCYnwqfuWs7ST2elr6TXn6YchCI',
    appId: '1:753602490293:android:1c6a1e96b7cb62353133fc',
    messagingSenderId: '753602490293',
    projectId: 'zee-calls',
    storageBucket: 'zee-calls.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBN8dotVgosaQB82e9miM0er6JhorNk6Ow',
    appId: '1:753602490293:ios:053e1ed8442771363133fc',
    messagingSenderId: '753602490293',
    projectId: 'zee-calls',
    storageBucket: 'zee-calls.appspot.com',
    iosClientId: '753602490293-64n3qp91ge4cbatse3pg6tdav850o06g.apps.googleusercontent.com',
    iosBundleId: 'com.zee.call.zeecall',
  );
}