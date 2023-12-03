import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                width: 75, // Sesuaikan dengan ukuran gambar
                height: 75, // Sesuaikan dengan ukuran gambar
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/splash.png'), // Ganti dengan path gambar kamu
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
