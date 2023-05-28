import 'package:flutter/material.dart';
import 'my_textfield.dart';
import 'my_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 50,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const ImageIcon(
                  AssetImage('images/hanger.png'),
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'TheLazyCloset',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextField(
                  controller: usernameController,
                  obscureText: false,
                  hintText: "Username",
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MyButton(
                  onTap: signUserIn,
                ),
                const SizedBox(
                  height: 180,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
