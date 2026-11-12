import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/catatan_store.dart';
import 'screens/animated_login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CatatanStore(),
      child: const StudyLogApp(),
    ),
  );
}

class StudyLogApp extends StatelessWidget {
  const StudyLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyLog',
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      home: const ModernLoginScreen(),
    );
  }
}
