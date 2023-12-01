import 'package:flutter/material.dart';
import 'dart:async'; // Diperlukan untuk timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk mengatur durasi splash screen sebelum berpindah ke halaman selanjutnya
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FlutterLogo(
          size: 200, // Atur ukuran logo sesuai keinginan Anda
        ),
      ),
    );
  }
}
