import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/vocabulary/presentation/screens/vocabulary_screen.dart';

/// Root application widget for LingoBreeze.
class LingoApp extends StatelessWidget {
  const LingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LingoBreeze',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const VocabularyScreen(),
    );
  }
}
