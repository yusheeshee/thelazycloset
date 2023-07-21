import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'album_page.dart';

class ClosetPage extends StatefulWidget {
  const ClosetPage({super.key});

  @override
  State<ClosetPage> createState() {
    return _ClosetPageState();
  }
}

class _ClosetPageState extends State<ClosetPage> {
  final user = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.email);
  final TextEditingController _albumNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future _createAlbum(String name) async {
    await user.collection("Closet Albums").add({
      'AlbumName': name,
      'Images': <String>[],
    });
  }

  Future<bool> albumExists(String name) async {
    QuerySnapshot querySnapshot = await user
        .collection("Closet Albums")
        .where('AlbumName', isEqualTo: name)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future _renameAlbum(String id, String newName) async {
    await user
        .collection("Closet Albums")
        .doc(id)
        .update({'AlbumName': newName});
  }

  Future _onDismissed(String id) async {
    await user.collection("Closet Albums").doc(id).delete();
  }

  Widget buildListTile(QueryDocumentSnapshot album) {
    final name = album['AlbumName'];
    final images = List<String>.from(album['Images']);
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 390,
            child: ListTile(
                tileColor: Colors.black,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      width: 1.0, color: Color.fromARGB(255, 208, 207, 207)),
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.all(15),
                title: Text(name,
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                leading: images.isEmpty
                    ? const Icon(
                        color: Color.fromARGB(255, 170, 169, 169),
                        Icons.image,
                        size: 40,
                      )
                    : Image.memory(base64Decode(images.first)),

                /// Image.file(File(album.images.first)),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PhotoAlbumScreen(
                          name: album['AlbumName'], id: album.id)));
                }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(width: 25),
                const Text("My Closet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(width: 200),
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text(
                                'Create Album',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'TsukimiRounded',
                                ),
                              ),
                              content: CupertinoTextField(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                controller: _albumNameController,
                                placeholder: 'Album name',
                                placeholderStyle: const TextStyle(
                                  color: Color.fromARGB(255, 172, 171, 171),
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
                                    onPressed: () async {
                                      _albumNameController.clear();
                                      Navigator.pop(context);
                                    }),
                                TextButton(
                                  child: const Text('Create',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  onPressed: () async {
                                    final albumName = _albumNameController.text;
                                    _albumNameController.clear();
                                    if (albumName.isNotEmpty) {
                                      if (await albumExists(albumName)) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                  title: const Text(
                                                    'Album already exists',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'TsukimiRounded',
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('Ok',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    )
                                                  ]);
                                            });
                                      } else {
                                        _createAlbum(albumName);
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      return;
                                    }
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: const Icon(Icons.add, color: Colors.white, size: 25),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                  stream: user.collection("Closet Albums").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final album = snapshot.data!.docs[index];
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                extentRatio: 0.3,
                                children: [
                                  SlidableAction(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15)),
                                    autoClose: true,
                                    icon: Icons.edit,
                                    backgroundColor: const Color.fromARGB(
                                        255, 238, 233, 192),
                                    onPressed: (context) async {
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title: const Text(
                                                'Rename Album',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'TsukimiRounded',
                                                ),
                                              ),
                                              content: CupertinoTextField(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                controller:
                                                    _albumNameController,
                                                placeholder: 'New album name',
                                                placeholderStyle:
                                                    const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 172, 171, 171),
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    onPressed: () {
                                                      _albumNameController
                                                          .clear();
                                                      Navigator.pop(context);
                                                    }),
                                                TextButton(
                                                  child: const Text('Rename',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  onPressed: () async {
                                                    final newName =
                                                        _albumNameController
                                                            .text;
                                                    _albumNameController
                                                        .clear();
                                                    if (newName.isNotEmpty) {
                                                      if (await albumExists(
                                                          newName)) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CupertinoAlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    'Album already exists',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'TsukimiRounded',
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                        child: const Text(
                                                                            'Ok',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold,
                                                                            )),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        })
                                                                  ]);
                                                            });
                                                      } else {
                                                        await _renameAlbum(
                                                            album.id, newName);
                                                        Navigator.pop(context);
                                                      }
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
                                  SlidableAction(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    backgroundColor: const Color.fromARGB(
                                        255, 213, 159, 156),
                                    icon: Icons.delete,
                                    autoClose: true,
                                    onPressed: (context) async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            title: const Text(
                                              'Delete album',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'TsukimiRounded',
                                              ),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this album?',
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                              TextButton(
                                                child: const Text('Confirm',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                onPressed: () async {
                                                  _onDismissed(album.id);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              child: buildListTile(album),
                            );
                          });
                    } else {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
