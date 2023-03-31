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
    apiKey: 'AIzaSyCITTPbc1SpNS_Bdk6_WgdM7xittAMZHr4',
    appId: '1:646048361902:web:ccbb1e17bba00aad832c3f',
    messagingSenderId: '646048361902',
    projectId: 'municipal-messaging',
    authDomain: 'municipal-messaging.firebaseapp.com',
    databaseURL: 'https://municipal-messaging-default-rtdb.firebaseio.com',
    storageBucket: 'municipal-messaging.appspot.com',
    measurementId: 'G-057BHQVHVS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD69ka8qmTtqVs1blnh4yBphfOQhnTIU2I',
    appId: '1:646048361902:android:94486fa8a6fa5996832c3f',
    messagingSenderId: '646048361902',
    projectId: 'municipal-messaging',
    databaseURL: 'https://municipal-messaging-default-rtdb.firebaseio.com',
    storageBucket: 'municipal-messaging.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpdkWpa5fGifC97DR0YmlDYSGgMgSJS-Q',
    appId: '1:646048361902:ios:eaa7d94aadddf656832c3f',
    messagingSenderId: '646048361902',
    projectId: 'municipal-messaging',
    databaseURL: 'https://municipal-messaging-default-rtdb.firebaseio.com',
    storageBucket: 'municipal-messaging.appspot.com',
    iosClientId: '646048361902-9cgpsuacib62npe5187sfo530tl5s0s5.apps.googleusercontent.com',
    iosBundleId: 'com.example.municipalMessaging',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDpdkWpa5fGifC97DR0YmlDYSGgMgSJS-Q',
    appId: '1:646048361902:ios:eaa7d94aadddf656832c3f',
    messagingSenderId: '646048361902',
    projectId: 'municipal-messaging',
    databaseURL: 'https://municipal-messaging-default-rtdb.firebaseio.com',
    storageBucket: 'municipal-messaging.appspot.com',
    iosClientId: '646048361902-9cgpsuacib62npe5187sfo530tl5s0s5.apps.googleusercontent.com',
    iosBundleId: 'com.example.municipalMessaging',
  );
}