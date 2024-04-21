// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseOptions;
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
Future<void> initializeFirebase() async {
 
}
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
    apiKey: 'AIzaSyC2AQ_6omYbaZ0xq3Rq4L6OygR07cd1ouY',
    appId: '1:29479499308:web:0370dd7af1e8b332a58389',
    messagingSenderId: '29479499308',
    projectId: 'algebraic-argon-420916',
    authDomain: 'algebraic-argon-420916.firebaseapp.com',
    databaseURL: 'https://algebraic-argon-420916-default-rtdb.firebaseio.com',
    storageBucket: 'algebraic-argon-420916.appspot.com',
    measurementId: 'G-1XYCCV5LW2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBW4fGwDtcPGVuW3h7Bjp6WtNw89xQ5VVo',
    appId: '1:29479499308:android:7ae3eeb7af86ee4ca58389',
    messagingSenderId: '29479499308',
    projectId: 'algebraic-argon-420916',
    storageBucket: 'algebraic-argon-420916.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDh8VpN6tm2XkAasgvYQo2UazWNG3jdjTQ',
    appId: '1:29479499308:ios:fd69bc819ec4fdfaa58389',
    messagingSenderId: '29479499308',
    projectId: 'algebraic-argon-420916',
    storageBucket: 'algebraic-argon-420916.appspot.com',
    iosBundleId: 'com.example.flutterApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDh8VpN6tm2XkAasgvYQo2UazWNG3jdjTQ',
    appId: '1:29479499308:ios:fd69bc819ec4fdfaa58389',
    messagingSenderId: '29479499308',
    projectId: 'algebraic-argon-420916',
    storageBucket: 'algebraic-argon-420916.appspot.com',
    iosBundleId: 'com.example.flutterApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2AQ_6omYbaZ0xq3Rq4L6OygR07cd1ouY',
    appId: '1:29479499308:web:f0703207a6917077a58389',
    messagingSenderId: '29479499308',
    projectId: 'algebraic-argon-420916',
    authDomain: 'algebraic-argon-420916.firebaseapp.com',
    storageBucket: 'algebraic-argon-420916.appspot.com',
    measurementId: 'G-S7TCHN5R7C',
  );
}