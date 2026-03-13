// GENERATED FILE — replace with output of: flutterfire configure
// Run: dart pub global activate flutterfire_cli
//      flutterfire configure
//
// The values below are placeholders. After running flutterfire configure,
// this file will be auto-populated with your real project credentials.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAYFlgEObCzlB-koI7YSBflJNXE0umfhA8',
    appId: '1:206458214080:web:2764a05cad377e022dbf25',
    messagingSenderId: '206458214080',
    projectId: 'cric-app-demo',
    authDomain: 'cric-app-demo.firebaseapp.com',
    storageBucket: 'cric-app-demo.firebasestorage.app',
    measurementId: 'G-39YVDM7E40',
  );

  // ── Replace each value with your real Firebase project config ──

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJ-iSdCt1mot-U_3CfzHnK4Gxn06dqgkQ',
    appId: '1:206458214080:android:4dc549bc26b750602dbf25',
    messagingSenderId: '206458214080',
    projectId: 'cric-app-demo',
    storageBucket: 'cric-app-demo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.cricmaidan',
  );
}