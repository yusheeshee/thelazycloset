import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

class ImagePage extends StatelessWidget {
  final String imagePath;
  final int index;

  const ImagePage({super.key, required this.imagePath, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const ImageIcon(
            AssetImage('images/backarrow.png'),
            size: 20,
            color: Colors.white,
          ),
        ),
        title: const ImageIcon(
          AssetImage('images/hanger.png'),
          size: 30,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: 'logo$index',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: Image.memory(base64Decode(imagePath)).image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
