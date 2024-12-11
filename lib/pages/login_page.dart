import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_mobile/pages/custom_widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  "Giriş Yap",
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
                  text: "Giriş Yap",
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Navigator.pushNamed(context, '/create_profile');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Hata: $e")),
                      );
                    }
                  },
                ),
              ],aaaa
            ),
          ),
        ],
      ),
    );
  }
}
