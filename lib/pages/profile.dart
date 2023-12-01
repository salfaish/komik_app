import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:komik_app/models/dataclass.dart';
import 'package:komik_app/models/dbservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:komik_app/auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyUser? _currentUser;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final email = user.email;
      if (email != null) {
        final myUser = await Database.getUser(email: email);
        if (myUser != null) {
          setState(() {
            _currentUser = myUser;
          });
        }
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(75.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna bayangan
                      spreadRadius: 1, // Sebaran bayangan
                      blurRadius: 24, // Jumlah blur pada bayangan
                      offset: Offset(0, 8), // Posisi bayangan (x, y)
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_currentUser?.profil ?? ""),
                  radius: 75,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${_currentUser?.nama ?? ""}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 22),
              ),
              const SizedBox(height: 10),
              Text(
                '${_currentUser?.email ?? ""}',
                style: TextStyle(
                    color: Color.fromRGBO(133, 133, 151, 1),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                    fontSize: 14),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Implement logout functionality
                  _auth.signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                style: ButtonStyle(
                  // Mengatur warna latar belakang tombol
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(97, 191, 173,
                          1)), // Ganti dengan warna yang diinginkan
                  // Mengatur ukuran tombol
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(236, 50)), // Sesuaikan ukuran yang diinginkan
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16, // Ganti dengan ukuran font yang diinginkan
                    color:
                        Colors.white, // Ganti dengan warna teks yang diinginkan
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
