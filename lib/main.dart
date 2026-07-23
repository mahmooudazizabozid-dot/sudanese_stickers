import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'stickers_home_screen.dart'; // تأكد من أن هذا الملف موجود

void main() async {
  // 1. ربط وتهيئة عناصر النظام الأساسية
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. تهيئة فايربيس بشكل آمن لكي لا يتوقف التطبيق
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("خطأ في تهيئة Firebase: $e");
  }

  runApp(const SudaneseStickersApp());
}

class SudaneseStickersApp extends StatelessWidget {
  const SudaneseStickersApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ملصقات سودانية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StickersHomeScreen(), // الصفحة الرئيسية التي أنشأناها مسبقاً
    );
  }
}

