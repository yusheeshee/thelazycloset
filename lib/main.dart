import 'package:flutter/material.dart';
import 'login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: LoginPage(),
    );
  }
}
