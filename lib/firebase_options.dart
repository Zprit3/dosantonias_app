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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAqId3MgqM5ujPk4Bw3cluORv25_kuohqM',
    appId: '1:1013378281721:web:47f3c59ae70aedfb3cb228',
    messagingSenderId: '1013378281721',
    projectId: 'antonias-29387',
    authDomain: 'antonias-29387.firebaseapp.com',
    storageBucket: 'antonias-29387.appspot.com',
    measurementId: 'G-HLGDHKL18F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBktl_GXuVIS_M36RkDISJL3-rtzcgGpHw',
    appId: '1:1013378281721:android:7bc0110d5eaa49283cb228',
    messagingSenderId: '1013378281721',
    projectId: 'antonias-29387',
    storageBucket: 'antonias-29387.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBv6To8WldL1d7ObYionGemv2ov905GGl0',
    appId: '1:1013378281721:ios:df6aeb8fff8660be3cb228',
    messagingSenderId: '1013378281721',
    projectId: 'antonias-29387',
    storageBucket: 'antonias-29387.appspot.com',
    iosClientId: '1013378281721-21t9a8ana3g5n0qr48e6q4b15hehcig1.apps.googleusercontent.com',
    iosBundleId: 'com.example.dosantoniasApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBv6To8WldL1d7ObYionGemv2ov905GGl0',
    appId: '1:1013378281721:ios:6e1b7635fa31df9a3cb228',
    messagingSenderId: '1013378281721',
    projectId: 'antonias-29387',
    storageBucket: 'antonias-29387.appspot.com',
    iosClientId: '1013378281721-qhmrapt3c8tc3ft4140mafsp7dt9p04q.apps.googleusercontent.com',
    iosBundleId: 'com.example.dosantoniasApp.RunnerTests',
  );
}