import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thelazycloset/album.dart';

class PhotoAlbumScreen extends StatefulWidget {
  final Album album;

  PhotoAlbumScreen({required this.album});

  @override
  _PhotoAlbumScreenState createState() => _PhotoAlbumScreenState();
}

class _PhotoAlbumScreenState extends State<PhotoAlbumScreen> {
  List<String> _photos = [];

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _photos.add(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
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
            Expanded(
              child: ListView.builder(
                itemCount: _photos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(File(_photos[index]));
                },
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
