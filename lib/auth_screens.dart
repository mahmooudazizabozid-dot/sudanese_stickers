import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'stickers_home_screen.dart';

// ==========================================
// 1. شاشة تسجيل الدخول (Login)
// ==========================================
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('الرجاء إدخال البريد وكلمة المرور')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StickersHomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في تسجيل الدخول: البريد أو كلمة المرور غير صحيحة')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل الدخول'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Text('تطبيق الملصقات السودانية', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
            Text('تطوير: محمود عبدالعزيز', style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 40),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()),
            ),
            SizedBox(height: 25),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text('تسجيل الدخول', style: TextStyle(fontSize: 18)),
                    ),
                  ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
              child: Text('ليس لديك حساب؟ إنشاء حساب جديد'),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. شاشة إنشاء حساب جديد (Sign Up)
// ==========================================
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('الرجاء ملء جميع الحقول')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // إنشاء وثيقة المستخدم في Firestore
      await FirebaseFirestore.instance.collection('Users').doc(credential.user!.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'sticker_downloads': 0,
        'is_subscribed': false,
        'subscription_end_date': null,
        'created_at': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StickersHomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء إنشاء الحساب')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء حساب جديد'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email), border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder())),
            SizedBox(height: 25),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _signUp,
                      child: Text('إنشاء الحساب', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
