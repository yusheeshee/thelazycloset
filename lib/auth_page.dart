import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'control_page.dart';
import 'loginorregister_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const ControlPage();
              } else {
                return const LoginOrRegisterPage();
              }
            }));
  }
}
