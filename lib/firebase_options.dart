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
    apiKey: 'AIzaSyDneRU6tVl-3SAxZReQCxw0yidHHjOLLsQ',
    appId: '1:871535005912:web:ec5d6c008caa4f0e6e47ad',
    messagingSenderId: '871535005912',
    projectId: 'instagram-abec5',
    authDomain: 'instagram-abec5.firebaseapp.com',
    databaseURL: 'https://instagram-abec5-default-rtdb.firebaseio.com',
    storageBucket: 'instagram-abec5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCllKe-4_tW6enUbK50Ohqjhgylhdpj-Y',
    appId: '1:871535005912:android:6124018ac90db1336e47ad',
    messagingSenderId: '871535005912',
    projectId: 'instagram-abec5',
    databaseURL: 'https://instagram-abec5-default-rtdb.firebaseio.com',
    storageBucket: 'instagram-abec5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiNHedTXPdB6iBKNSWr_jJzR318qkF5-U',
    appId: '1:871535005912:ios:f88cbf52268b1b2b6e47ad',
    messagingSenderId: '871535005912',
    projectId: 'instagram-abec5',
    databaseURL: 'https://instagram-abec5-default-rtdb.firebaseio.com',
    storageBucket: 'instagram-abec5.appspot.com',
    iosClientId: '871535005912-981brunj5g3dsjbn3tolducjbk0lsgan.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDiNHedTXPdB6iBKNSWr_jJzR318qkF5-U',
    appId: '1:871535005912:ios:f88cbf52268b1b2b6e47ad',
    messagingSenderId: '871535005912',
    projectId: 'instagram-abec5',
    databaseURL: 'https://instagram-abec5-default-rtdb.firebaseio.com',
    storageBucket: 'instagram-abec5.appspot.com',
    iosClientId: '871535005912-981brunj5g3dsjbn3tolducjbk0lsgan.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagramClone',
  );
}
