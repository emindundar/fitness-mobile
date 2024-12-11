import 'package:fitness_mobile/pages/create_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_mobile/pages/custom_widgets.dart';
import 'package:fitness_mobile/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/arkaplan.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    color: Color(0xFF0C454E),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "E-posta gir.",
                  controller: emailController,
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: "Şifre gir.",
                  controller: passwordController,
                  obscureText: true,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "E-posta ile Kaydol",
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Navigator.pushNamed(context, '/home');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Hata: $e")),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "Giriş Yap",
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: ("Google ile Giriş"),
                  onPressed: () async {
                    final user = await signInWithGoogle();
                    if (user != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => CreateProfilePage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Hata"),
                          content: const Text("Google ile giriş yapılamadı."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Tamam"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
