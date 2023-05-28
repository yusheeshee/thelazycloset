import 'package:flutter/material.dart';

class EnlargePage extends StatelessWidget {
  final String imagePath;
  final int index;

  const EnlargePage({super.key, required this.imagePath, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const ImageIcon(
                      AssetImage('images/backarrow.png'),
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 115),
                const ImageIcon(
                  AssetImage('images/hanger.png'),
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Hero(
                tag: 'logo$index',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
