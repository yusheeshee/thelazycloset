import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const TheLazyCloset());
}

class TheLazyCloset extends StatelessWidget {
  const TheLazyCloset({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'TsukimiRounded',
      ),
      home: LoginPage(),
    );
  }
}
