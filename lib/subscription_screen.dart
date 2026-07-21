import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final TextEditingController _receiptController = TextEditingController();
  bool _isSending = false;

  Future<void> _submitReceipt() async {
    String receipt = _receiptController.text.trim();
    if (receipt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('الرجاء إدخال رقم الإشعار')));
      return;
    }

    setState(() => _isSending = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

        await FirebaseFirestore.instance.collection('Receipts').add({
          'user_id': user.uid,
          'user_name': userDoc['name'] ?? 'مستخدم',
          'user_phone': userDoc['phone'] ?? 'بدون رقم',
          'receipt_number': receipt,
          'status': 'pending', // في انتظار موافقة محمود
          'created_at': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إرسال الإشعار لـ محمود عبدالعزيز. سيتم التفعيل فور التأكد!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء إرسال الإشعار')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفعيل الاشتراك الأسبوعي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.lock_clock, size: 70, color: Colors.orange),
            SizedBox(height: 15),
            Text('وصلت للحد المجاني (10 ملصقات)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('رسوم الاشتراك: 5000 جنيه سوداني / أسبوع', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            Divider(height: 30),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Text('طريقة الدفع: تطبيق بنكك (بنك الخرطوم)', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('رقم الحساب: 8607733', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800])),
                  Text('اسم الحساب: محمود عبدالعزيز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(height: 25),
            TextField(
              controller: _receiptController,
              decoration: InputDecoration(
                labelText: 'أدخل رقم عملية التحويل (الإشعار)',
                prefixIcon: Icon(Icons.receipt_long),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isSending
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _submitReceipt,
                      child: Text('إرسال لتأكيد الدفع', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
