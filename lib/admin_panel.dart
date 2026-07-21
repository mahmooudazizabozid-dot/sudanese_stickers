import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatelessWidget {
  // دالة تفعيل اشتراك المستخدم أسبوع كامل عند التأكد من استلام الـ 5000 جنيه في بنكك
  Future<void> _activateSubscription(BuildContext context, String receiptId, String userId) async {
    DateTime now = DateTime.now();
    DateTime endDate = now.add(Duration(days: 7)); // تفعيل أسبوع

    // 1. تحديث حالة المستخدم إلى مشترك وتأريخ الانتهاء
    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'is_subscribed': true,
      'subscription_end_date': Timestamp.fromDate(endDate),
    });

    // 2. تحديث حالة الإشعار إلى مقبول
    await FirebaseFirestore.instance.collection('Receipts').doc(receiptId).update({
      'status': 'approved',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تفعيل اشتراك المستخدم بنجاح لمدة أسبوع!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم المالك: محمود عبدالعزيز'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Receipts').where('status', isEqualTo: 'pending').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var receipts = snapshot.data!.docs;

          if (receipts.isEmpty) {
            return Center(child: Text('لا توجد طلبات اشتراك جديدة حالياً'));
          }

          return ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              var item = receipts[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('رقم الإشعار: ${item['receipt_number']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
                  subtitle: Text('الاسم: ${item['user_name']}\nالهاتف: ${item['user_phone']}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _activateSubscription(context, item.id, item['user_id']),
                    child: Text('تأكيد الدفع وتفعيل 7 أيام', style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

