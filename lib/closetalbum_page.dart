import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'removeapi.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhotoAlbumScreen extends StatefulWidget {
  final String name;
  final String id;

  const PhotoAlbumScreen({super.key, required this.name, required this.id});

  @override
  State<PhotoAlbumScreen> createState() => _PhotoAlbumScreenState();
}

class _PhotoAlbumScreenState extends State<PhotoAlbumScreen> {
  final albums = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('Closet Albums');

  @override
  void initState() {
    super.initState();
  }

  Future _pickImage(ImageSource source) async {
    final album = albums.doc(widget.id);
    DocumentSnapshot docSnapshot = await album.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    final images = List<String>.from(data['Images']);
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      final croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path, // Set desired aspect ratio
          compressQuality: 100, // Adjust the compression quality as needed
          maxWidth: 500, // Limit the maximum width of the cropped image
          maxHeight: 500,
          uiSettings: [
            AndroidUiSettings(
              backgroundColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              toolbarColor: Colors.black,
              statusBarColor: Colors.black,
            )
          ] // Limit the maximum height of the cropped image
          );
      if (croppedImage != null) {
        final removeApi = RemoveAPI();
        final removedBgImage = await removeApi.removeBgApi(croppedImage.path);
        images.add(base64Encode(removedBgImage));
        album.update({'Images': images});
      }
    }
    return;
  }

  Future deleteImage(int index) async {
    final album = albums.doc(widget.id);
    DocumentSnapshot docSnapshot = await album.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    final images = List<String>.from(data['Images']);
    images.removeAt(index);
    album.update({'Images': images});
  }

  @override
  Widget build(BuildContext context) {
    final album = albums.doc(widget.id);
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
        title: Text(widget.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: StreamBuilder(
                  stream: album.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final images =
                          List<String>.from(snapshot.data!['Images']);
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final ImageProvider<Object> image =
                              Image.memory(base64Decode(images[index])).image;
                          return RawMaterialButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ImagePage(image: image)),
                              );
                            },
                            onLongPress: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text(
                                      'Delete image',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'TsukimiRounded',
                                      ),
                                    ),
                                    content: const Text(
                                      'Are you sure you want to delete this image?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'TsukimiRounded',
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      TextButton(
                                        child: const Text('Delete',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onPressed: () async {
                                          deleteImage(index);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: image,

                                /// Image.file(File(album.images[index])).image,
                                fit: BoxFit.cover,
                              ),
                            )),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                  }),
            )),
            RawMaterialButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.grey[300],
                  builder: (BuildContext context) {
                    return SizedBox(
                      width: 50,
                      height: 155,
                      child: Column(children: [
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: const BorderSide(width: 0.5)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          title: const Text(
                            "Choose from gallery",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          leading: const Icon(
                            Icons.image,
                            color: Colors.black,
                          ),
                          onTap: () async {
                            _pickImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: const BorderSide(width: 1.0)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            title: const Text(
                              "Take photo",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            leading:
                                const Icon(Icons.camera, color: Colors.black),
                            onTap: () async {
                              _pickImage(ImageSource.camera);
                              Navigator.pop(context);
                            }),
                      ]),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
