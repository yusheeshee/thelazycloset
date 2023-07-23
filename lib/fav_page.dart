import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'control_page.dart';
import 'image_page.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final user = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.email);

  @override
  void initState() {
    super.initState();
  }

/*  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getImages() async {
    final albumsSnapshot = await user.collection('Outfit Albums').get();
    final favoriteImages = <DocumentSnapshot<Map<String, dynamic>>>[];
    for (final albumSnapshot in albumsSnapshot.docs) {
      final albumId = albumSnapshot.id;
      final imagesSnapshot = await user
          .collection('Outfit Albums')
          .doc(albumId)
          .collection('Images')
          .where('fav', isEqualTo: true)
          .get(); // Replace 'images' with the actual name of the images collection

      favoriteImages.addAll(imagesSnapshot.docs);
    }

    return favoriteImages;
  } */

  Future unFav(String id) async {
    final albumId = await user.collection('Favourites').doc(id).get();
    await user.collection('Favourites').doc(id).delete();
    await user
        .collection('Outfit Albums')
        .doc(albumId['albumid'])
        .collection('Images')
        .doc(id)
        .update({'fav': false});
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              title: const Text(
                'Removed from Favourites',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'TsukimiRounded',
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Ok',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () => Navigator.pop(context),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ControlPage()));
          },
          child: const ImageIcon(
            AssetImage('images/backarrow.png'),
            size: 20,
            color: Colors.white,
          ),
        ),
        title: const Text('Favourites',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: StreamBuilder(
                  stream: user.collection('Favourites').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final obj = snapshot.data!.docs[index];
                          final ImageProvider<Object> image =
                              Image.file(File(obj['path'])).image;
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
                                      'Remove from Favourites',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'TsukimiRounded',
                                      ),
                                    ),
                                    content: const Text(
                                      'Are you sure you want to remove this image from Favourites?',
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
                                        child: const Text('Remove',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onPressed: () async {
                                          unFav(obj.id);
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
