// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAxbwNIXiBZBWGhmba7khESsrk5yng8SPE',
    appId: '1:469681332414:web:65e9f879b491d73d217eef',
    messagingSenderId: '469681332414',
    projectId: 'cat-care-15e24',
    authDomain: 'cat-care-15e24.firebaseapp.com',
    storageBucket: 'cat-care-15e24.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbMcSbx3jC4EuINsswT0ynMMz0M7VmgNE',
    appId: '1:469681332414:android:2ac5347ddba8bb6f217eef',
    messagingSenderId: '469681332414',
    projectId: 'cat-care-15e24',
    storageBucket: 'cat-care-15e24.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxbwNIXiBZBWGhmba7khESsrk5yng8SPE',
    appId: '1:469681332414:web:7af21a3866598250217eef',
    messagingSenderId: '469681332414',
    projectId: 'cat-care-15e24',
    authDomain: 'cat-care-15e24.firebaseapp.com',
    storageBucket: 'cat-care-15e24.appspot.com',
  );
}
