import 'package:flutter/material.dart';
import 'pages/auth/login_page.dart';

void main() {
  runApp(const MyEkskulApp());
}

class MyEkskulApp extends StatelessWidget {
  const MyEkskulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyEkskul',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F8FF),
      ),
      home: const LoginPage(),
    );
  }
}