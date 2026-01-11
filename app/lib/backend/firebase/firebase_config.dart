import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB4UDxpAWp6my_kJCBeU8ZIcBkuoyn7-F0",
            authDomain: "habu-1gxak2.firebaseapp.com",
            projectId: "habu-1gxak2",
            storageBucket: "habu-1gxak2.appspot.com",
            messagingSenderId: "959927583222",
            appId: "1:959927583222:web:d1bf5ad476dbfca0ac87d7"));
  } else {
    await Firebase.initializeApp();
  }
}
