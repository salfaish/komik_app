import 'package:komik_app/admin/admin.dart';
import 'package:komik_app/main.dart';
import 'package:komik_app/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:komik_app/auth/register.dart';
import 'package:komik_app/pages/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // if (email == "admin@gmail.com" && password == "123456") {
    //   // Jika email dan kata sandi sesuai dengan admin
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => AdminPage()));
    // } else {
    User? user =
        await _authService.loginWithEmailandPassword(email, password, context);

    if (user != null) {
      // Jika login berhasil dan bukan admin, arahkan ke halaman HomeWidget
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed"),
          backgroundColor: Colors.red,
        ),
      );
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
              "Login to continue",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "Email Address",
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.key),
                hintText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(97, 191, 173, 1)),
                  onPressed: () {
                    login();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don’t have an account?"),
                const SizedBox(width: 4.0),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: const Text(
                      "Register.",
                      style: TextStyle(color: Color.fromRGBO(97, 191, 173, 1)),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
