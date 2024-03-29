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
    apiKey: 'AIzaSyAAJfelW1p9Y7jSYS1k3EaIypcqhXdUnow',
    appId: '1:78643950643:web:b463081f3fd76fbdf9df46',
    messagingSenderId: '78643950643',
    projectId: 'app-pets-4ac92',
    authDomain: 'app-pets-4ac92.firebaseapp.com',
    storageBucket: 'app-pets-4ac92.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbxk6ubGYrDhgMckk_eWkwk-lSiuvqmJQ',
    appId: '1:78643950643:android:95f196a491a63b54f9df46',
    messagingSenderId: '78643950643',
    projectId: 'app-pets-4ac92',
    storageBucket: 'app-pets-4ac92.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIn99XA_541awHb6pduqrnGZMMO6HDuEc',
    appId: '1:78643950643:ios:f42cdba38e8056f2f9df46',
    messagingSenderId: '78643950643',
    projectId: 'app-pets-4ac92',
    storageBucket: 'app-pets-4ac92.appspot.com',
    iosBundleId: 'com.allan_miller.replicaGoogleClassroom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDIn99XA_541awHb6pduqrnGZMMO6HDuEc',
    appId: '1:78643950643:ios:77edf03ebb1aeca0f9df46',
    messagingSenderId: '78643950643',
    projectId: 'app-pets-4ac92',
    storageBucket: 'app-pets-4ac92.appspot.com',
    iosBundleId: 'com.allan_miller.replicaGoogleClassroom.RunnerTests',
  );
}
