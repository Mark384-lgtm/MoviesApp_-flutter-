// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDC02B9cx91T-84XuwWwueN2NplZqSjPM',
    appId: '1:158516261779:android:3b8b65fa5077ffa95bae66',
    messagingSenderId: '158516261779',
    projectId: 'movies-20f8c',
    storageBucket: 'movies-20f8c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4tG8nUsvb3R4vOXisEoVr11dNG1gstZ0',
    appId: '1:158516261779:ios:e263b544d84d60a15bae66',
    messagingSenderId: '158516261779',
    projectId: 'movies-20f8c',
    storageBucket: 'movies-20f8c.firebasestorage.app',
    iosBundleId: 'com.ahmedali.movies',
  );
}
