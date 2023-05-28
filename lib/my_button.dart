import 'package:flutter/material.dart';
import 'choose_page.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;

  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonTheme(
          child: RawMaterialButton(
            fillColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChoosePage(),
                ),
              );
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 135,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: const Center(
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
