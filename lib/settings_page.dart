import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:thelazycloset/auth_page.dart';
import 'package:thelazycloset/loginorregister_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final _usernameController = TextEditingController();
  String username = 'No username yet';
  String profilePic = '';

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.transparent,
        all: 8,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 15,
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthPage()));
  } //change image type here acc

  void _updateUsername() {
    setState(() {
      username = _usernameController.text;
    });
    _usernameController.clear();
    Navigator.pop(context); // Return to the previous screen
  }

  Future _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path, // Set desired aspect ratio
        compressQuality: 100, // Adjust the compression quality as needed
        maxWidth: 500, // Limit the maximum width of the cropped image
        maxHeight: 500, // Limit the maximum height of the cropped image
      );
      if (croppedImage != null) {
        setState(() {
          profilePic = croppedImage.path;
        });
      }
    }
  }

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
              size: 18,
              color: Colors.white,
            ),
          ),
          title: const Text('Settings',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 22)),
          centerTitle: true,
        ),
        body: ListView(children: [
          const SizedBox(
            height: 25,
          ),
          Stack(alignment: Alignment.topCenter, children: [
            Container(
              width: 80,
              height: 80,
              decoration: profilePic != ''
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: FileImage(File(profilePic)),
                          fit: BoxFit.contain))
                  : const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: AssetImage('images/user.png'),
                      )),
              child: RawMaterialButton(
                shape: const CircleBorder(side: BorderSide(width: 80)),
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
                            onTap: () {
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
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.pop(context);
                              }),
                        ]),
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 58,
              right: 140,
              child: buildEditIcon(Colors.transparent),
            ),
          ]),
          const SizedBox(height: 40),
          Container(
            height: 90,
            padding: const EdgeInsets.fromLTRB(15, 13, 8, 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(children: [
              const Row(
                children: [
                  const Text('Username',
                      style: TextStyle(
                          color: Color.fromARGB(255, 145, 144, 144),
                          fontSize: 15,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: 380,
                height: 35,
                child: TextField(
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 13),
                  controller: _usernameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: username,
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 15),
          Container(
              height: 90,
              padding: const EdgeInsets.fromLTRB(15, 15, 8, 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Email',
                        style: TextStyle(
                            color: Color.fromARGB(255, 145, 144, 144),
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(height: 18),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    user.email!,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ]),
              ])),
          const SizedBox(height: 300),
          IconButton(
              onPressed: () async => {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text(
                              'Sign out',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TsukimiRounded',
                              ),
                            ),
                            content: const Text(
                              'Are you sure you want to sign out?',
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
                                child: const Text('Confirm',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    )),
                                onPressed: () async {
                                  signOut();
                                },
                              ),
                            ],
                          );
                        })
                  },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ]));
  }
}
