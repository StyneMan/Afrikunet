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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDI9kp0ds3SH7aNqGR_YNcmG22HskPtwiw',
    appId: '1:964741321159:android:9c9b587f839cace138c9e2',
    messagingSenderId: '964741321159',
    projectId: 'prohelp-95c57',
    storageBucket: 'prohelp-95c57.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDI9kp0ds3SH7aNqGR_YNcmG22HskPtwiw',
    appId: '1:964741321159:ios:75454900ec877f9d38c9e2',
    messagingSenderId: '964741321159',
    projectId: 'prohelp-95c57',
    storageBucket: 'prohelp-95c57.appspot.com',
    androidClientId:
        '964741321159-utj0quhj8o5otmd3gptfbohk7r6lr3t3.apps.googleusercontent.com',
    iosClientId:
        '964741321159-28qcackd3m76obnp0srfo7oebc1cke6r.apps.googleusercontent.com',
    iosBundleId: 'com.afrikunet.app',
  );
}
