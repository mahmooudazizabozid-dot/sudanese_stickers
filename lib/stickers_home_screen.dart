import 'package:flutter/material.dart';

class StickersHomeScreen extends StatelessWidget {
  const StickersHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملصقات سودانية'),
      ),
      body: const Center(
        child: Text('مرحباً بك في صفحة الملصقات الرئيسية'),
      ),
    );
  }
}
