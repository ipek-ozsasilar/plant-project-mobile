// ignore_for_file: lines_longer_than_80_chars
// Android: android/app/google-services.json ile uyumlu.
// iOS / Web / Windows için: `dart pub global activate flutterfire_cli` → `flutterfire configure`

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase [Firebase.initializeApp] için platform seçenekleri.
abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web için Firebase henüz yapılandırılmadı. flutterfire configure çalıştırın.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'iOS/macOS için GoogleService-Info.plist ve flutterfire configure gerekir.',
        );
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase bu projede mobil için kuruldu. Test: Android emülatör veya USB ile telefon '
          '(flutter run -d <android_id>). Windows Geliştirici Modu + tam yeniden derleme de gerekebilir.',
        );
      default:
        throw UnsupportedError('Desteklenmeyen platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsyX6-yLMTqTKBqYLJUxacuvLWLXlzl0A',
    appId: '1:817892606519:android:805113d5abf0ded773b5b2',
    messagingSenderId: '817892606519',
    projectId: 'plant-project-mobile',
    storageBucket: 'plant-project-mobile.firebasestorage.app',
  );
}
