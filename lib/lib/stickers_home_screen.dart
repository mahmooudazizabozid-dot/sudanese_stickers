import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../subscription_screen.dart';
import '../admin_panel.dart';
import '../auth_screens.dart';

class StickersHomeScreen extends StatelessWidget {
  // البريد الإلكتروني الخاص بك كأدمن (محمود عبدالعزيز)
  final String myAdminEmail = "Mahmooudazizabozid@gmail.com";

  Future<void> _handleStickerDownload(BuildContext context, DocumentSnapshot userDoc) async {
    Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
    int downloads = data?['sticker_downloads'] ?? 0;
    bool isSubscribed = data?['is_subscribed'] ?? false;
    Timestamp? endDate = data?['subscription_end_date'];

    bool hasActiveSub = isSubscribed && endDate != null && endDate.toDate().isAfter(DateTime.now());

    // التحقق من تجاوز الـ 10 ملصقات المجانية
    if (downloads >= 10 && !hasActiveSub) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionScreen()));
    } else {
      await FirebaseFirestore.instance.collection('Users').doc(userDoc.id).update({
        'sticker_downloads': downloads + 1,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة مجموعة الملصقات إلى الواتساب بنجاح!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('الملصقات السودانية'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var userDoc = snapshot.data!;
          var userData = userDoc.data() as Map<String, dynamic>?;
          int downloads = userData?['sticker_downloads'] ?? 0;
          bool isSubscribed = userData?['is_subscribed'] ?? false;

          return Column(
            children: [
              // شريط حالة المستخدم
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.green.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('التحميلات المجانية: $downloads / 10'),
                    Text(
                      isSubscribed ? 'الحالة: مشترك 🟢' : 'الحالة: مجاني 🔴',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // 🔒 زر لوحة التحكم يظهر حصراً إذا كان البريد هو Mahmooudazizabozid@gmail.com
              if (currentUser?.email == myAdminEmail) ...[
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: Icon(Icons.admin_panel_settings),
                  label: Text('لوحة تحكم محمود عبدالعزيز'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminPanelScreen()),
                    );
                  },
                ),
              ],

              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Icon(Icons.emoji_emotions, size: 40, color: Colors.green),
                        title: Text('حزمة الملصقات السودانية رقم ${index + 1}'),
                        subtitle: Text('تحتوي على ملصقات سودانية تعبيرية وكوميدية'),
                        trailing: ElevatedButton(
                          onPressed: () => _handleStickerDownload(context, userDoc),
                          child: Text('إضافة للواتساب'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

