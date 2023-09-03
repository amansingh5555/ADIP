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
    apiKey: 'AIzaSyB0IVPx6iRXBVCoWw2uA5J9-Eqge4jY4o8',
    appId: '1:60404697807:web:4ff87298dec974736505ba',
    messagingSenderId: '60404697807',
    projectId: 'add-608e3',
    authDomain: 'add-608e3.firebaseapp.com',
    storageBucket: 'add-608e3.appspot.com',
    measurementId: 'G-D3MR5S2HQ4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7T0itTxxZMNXzovdK1ATHdNp-XaNkNLA',
    appId: '1:60404697807:android:9177e9e744b3d1a96505ba',
    messagingSenderId: '60404697807',
    projectId: 'add-608e3',
    storageBucket: 'add-608e3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCze-d9JpauxlYuXeFt_T1Iqp32YIsO7SA',
    appId: '1:60404697807:ios:e9f92da3e8665a6a6505ba',
    messagingSenderId: '60404697807',
    projectId: 'add-608e3',
    storageBucket: 'add-608e3.appspot.com',
    iosClientId: '60404697807-t12l3fifisn99tf32bes0k8kl9fpu1n0.apps.googleusercontent.com',
    iosBundleId: 'com.example.phirapply',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCze-d9JpauxlYuXeFt_T1Iqp32YIsO7SA',
    appId: '1:60404697807:ios:397cd343f94a76486505ba',
    messagingSenderId: '60404697807',
    projectId: 'add-608e3',
    storageBucket: 'add-608e3.appspot.com',
    iosClientId: '60404697807-cp5qiub9c7svhpc4dcqc6h1gam8soqb9.apps.googleusercontent.com',
    iosBundleId: 'com.example.phirapply.RunnerTests',
  );
}
