import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/catatan_store.dart';
import 'screens/animated_login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final catatanStore = CatatanStore();
  try {
    await catatanStore.muatCatatan();
  } catch (e) {
    debugPrint('Inisialisasi catatan awal dilewati: $e');
  }

  runApp(
    ChangeNotifierProvider<CatatanStore>.value(
      value: catatanStore,
      child: const StudyLogApp(),
    ),
  );
}

class StudyLogApp extends StatelessWidget {
  const StudyLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2383E2),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        fontFamily: 'Inter',
      ),
      home: const ModernLoginScreen(),
    );
  }
}
