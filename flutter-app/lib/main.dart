import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for warm light theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFAF7F2),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Firebase (optional — app works via API without it)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized');
  } catch (e) {
    debugPrint('⚠️ Firebase not configured — running in API-only mode');
    debugPrint('   Reason: $e');
    debugPrint('   The app will use the Node.js API for all operations.');
  }

  runApp(
    const ProviderScope(
      child: LingoApp(),
    ),
  );
}
