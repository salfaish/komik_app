import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:komik_app/auth/login.dart';
import 'package:komik_app/models/dataclass.dart';
import 'package:komik_app/models/dbservices.dart';
// import 'package:komik_app/models/user.dart'; // Assuming you have a User model

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        MyUser newUser = MyUser(
          // Assuming 'MyUser' is a custom user model
          nama: _namaController.text,
          email: email,
          profil: "https://cdn-icons-png.flaticon.com/512/146/146031.png",
          // Add any other necessary fields
        );

        await Database.tambahUser(user: newUser); // Save user data to Firestore

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("User successfully created"),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacementNamed(
            context, '/home'); // Navigate to home after successful registration
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to create user"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Register",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: "Nama Lengkap",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "Email Address",
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.key),
                hintText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(97, 191, 173, 1),
                ),
                onPressed: () {
                  register(); // Call register function
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                const SizedBox(width: 8.0),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login.",
                    style: TextStyle(color: Color.fromRGBO(97, 191, 173, 1)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
