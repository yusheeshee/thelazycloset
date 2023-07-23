import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:thelazycloset/auth_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.email);
  final _usernameController = TextEditingController();

  Widget buildEditIcon(Color color) => buildCircle(
      color: Colors.transparent,
      all: 8,
      child: RawMaterialButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                          color: Colors.black, fontWeight: FontWeight.w600),
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
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      leading: const Icon(Icons.camera, color: Colors.black),
                      onTap: () {
                        _pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      }),
                ]),
              );
            },
          );
        },
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 15,
        ),
      ));

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
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  } //change image type here acc

  Future _updateUsername(String newUsername) async {
    await user.update({'username': newUsername});
  }

  Future _pickImage(ImageSource source) async {
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
          ] // Limit the // Limit the maximum height of the cropped image
          );
      if (croppedImage != null) {
        final imageFile = File(croppedImage.path);
        final String imagePath = imageFile.path;
        user.update({'profilepic': imagePath});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: const ImageIcon(
            AssetImage('images/hanger.png'),
            size: 30,
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: user.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String username = snapshot.data!['username'];
                String email = user.id;
                final profilepic = snapshot.data!['profilepic'];
                return ListView(children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(alignment: Alignment.topCenter, children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: profilepic != ''
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              image: DecorationImage(
                                  image: Image.file(File(profilepic)).image,
                                  fit: BoxFit.contain))
                          : const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: AssetImage('images/user.png'),
                              )),
                    ),
                    Positioned(
                      top: 60,
                      right: 100,
                      child: buildEditIcon(Colors.transparent),
                    ),
                  ]),
                  const SizedBox(height: 40),
                  Container(
                    height: 90,
                    padding: const EdgeInsets.fromLTRB(15, 13, 8, 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(children: [
                      Row(
                        children: [
                          Text('Username',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 380,
                        height: 35,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft, // Set this
                            padding: EdgeInsets.zero, // and this
                          ),
                          child: Text(username,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text(
                                      'Edit Username',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'TsukimiRounded',
                                      ),
                                    ),
                                    content: CupertinoTextField(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'TsukimiRounded'),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      controller: _usernameController,
                                      placeholder: 'New username',
                                      placeholderStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 172, 171, 171),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
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
                                            _usernameController.clear();
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
                                          final newName =
                                              _usernameController.text;
                                          _usernameController.clear();
                                          if (newName.isNotEmpty) {
                                            await _updateUsername(newName);
                                            Navigator.pop(context);
                                          } else {
                                            return;
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  Container(
                      height: 90,
                      padding: const EdgeInsets.fromLTRB(15, 15, 8, 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Email',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            email,
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                      ])),
                  const SizedBox(height: 190),
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
                                        child: const Text('Sign out',
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
                ]);
              } else {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
            }));
  }
}
