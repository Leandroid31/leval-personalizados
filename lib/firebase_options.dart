// firebase_options.dart (exemplo)
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'SUA_API_KEY',
      appId: 'SEU_APP_ID',
      messagingSenderId: 'SEU_MESSAGING_SENDER_ID',
      projectId: 'SEU_PROJECT_ID',
      storageBucket: 'SEU_BUCKET.appspot.com',
    );
  }
}
