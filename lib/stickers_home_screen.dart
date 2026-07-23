import 'package:flutter/material.dart';
import 'subscription_screen.dart';
import 'admin_panel_screen.dart';

class StickersHomeScreen extends StatelessWidget {
  const StickersHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملصقات سودانية'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'مرحباً بك في تطبيق ملصقات سودانية',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // زر الانتقال لصفحة الاشتراكات
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                );
              },
              icon: const Icon(Icons.star, color: Colors.amber),
              label: const Text('اشتراكات التطبيق', style: TextStyle(fontSize: 16)),
            ),
            
            const SizedBox(height: 15),

            // زر الانتقال للوحة التحكم الإدارية
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                );
              },
              icon: const Icon(Icons.admin_panel_settings, color: Colors.blue),
              label: const Text('لوحة التحكم الإدارية', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

