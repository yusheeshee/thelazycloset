import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TheLazyCloset());
}

class TheLazyCloset extends StatelessWidget {
  const TheLazyCloset({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TheLazyCloset',
      theme: ThemeData(
        fontFamily: 'TsukimiRounded',
      ),
      home: const AuthPage(),
    );
  }
}
