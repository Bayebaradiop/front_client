import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY_WEB',
    appId: '1:123456789:web:abcdef',
    messagingSenderId: '123456789',
    projectId: 'medibook-app',
    authDomain: 'medibook-app.firebaseapp.com',
    storageBucket: 'medibook-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY_ANDROID',
    appId: '1:123456789:android:abcdef',
    messagingSenderId: '123456789',
    projectId: 'medibook-app',
    storageBucket: 'medibook-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY_IOS',
    appId: '1:123456789:ios:abcdef',
    messagingSenderId: '123456789',
    projectId: 'medibook-app',
    storageBucket: 'medibook-app.appspot.com',
    iosClientId: '123456789abcdef.apps.googleusercontent.com',
    iosBundleId: 'com.medibook.medibookMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY_IOS',
    appId: '1:123456789:macos:abcdef',
    messagingSenderId: '123456789',
    projectId: 'medibook-app',
    storageBucket: 'medibook-app.appspot.com',
    iosClientId: '123456789abcdef.apps.googleusercontent.com',
    iosBundleId: 'com.medibook.medibookMobile',
  );
}
