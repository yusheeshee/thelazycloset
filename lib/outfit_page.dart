import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fav_page.dart';
import 'outfitalbum_page.dart';

class OutfitPage extends StatefulWidget {
  const OutfitPage({super.key});

  @override
  State<OutfitPage> createState() {
    return _OutfitPageState();
  }
}

class _OutfitPageState extends State<OutfitPage> {
  final user = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.email);
  final TextEditingController _albumNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future _createAlbum(String name) async {
    await user
        .collection("Outfit Albums")
        .add({'AlbumName': name, 'CreateTime': Timestamp.now()});
  }

  Future<bool> albumExists(String name) async {
    QuerySnapshot querySnapshot = await user
        .collection("Outfit Albums")
        .where('AlbumName', isEqualTo: name)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future _renameAlbum(String id, String newName) async {
    await user
        .collection("Outfit Albums")
        .doc(id)
        .update({'AlbumName': newName});
  }

  Future _onDismissed(String id) async {
    final data = await user
        .collection('Outfit Albums')
        .doc(id)
        .collection('Images')
        .get();
    for (var imageSnapshot in data.docs) {
      final imageId = imageSnapshot.id;
      user.collection('Favourites').doc(imageId).delete();
    }

    await user.collection("Outfit Albums").doc(id).delete();
  }

  Future<String> getUsername() async {
    final userobj = await user.get();
    return userobj.data()!['username'];
  }

  Future<Widget> displayTitle() async {
    final userobj = await user.get();
    final String username = userobj.data()!['username'];
    return Text(username + ("'s Outfits"),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.w600,
        ));
  }

  Future<Widget> buildListTile(DocumentSnapshot album) async {
    final name = album['AlbumName'];
    final QuerySnapshot querySnapshot = await user
        .collection('Outfit Albums')
        .doc(album.id)
        .collection('Images')
        .limit(1)
        .get();
    if (querySnapshot.size == 0) {
      return Center(
        child: Column(
          children: [
            SizedBox(
              width: 390,
              child: ListTile(
                  tileColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  leading: const SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        color: Color.fromARGB(255, 170, 169, 169),
                        Icons.image,
                        size: 40,
                      )),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PhotoAlbumScreen(name: name, id: album.id)));
                  }),
            ),
          ],
        ),
      );
    } else {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      final String path = data['path'];
      return Center(
        child: Column(
          children: [
            SizedBox(
              width: 390,
              child: ListTile(
                  tileColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.file(File(path), fit: BoxFit.cover)),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PhotoAlbumScreen(name: name, id: album.id)));
                  }),
            ),
          ],
        ),
      );
    }
  }

  Future<Widget> buildFavTile(QuerySnapshot album) async {
    const name = 'Favourites';
    if (album.size == 0) {
      return Center(
        child: Column(
          children: [
            SizedBox(
              width: 390,
              child: ListTile(
                  tileColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  title: const Text(name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  leading: const SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        color: Color.fromARGB(255, 170, 169, 169),
                        Icons.image,
                        size: 40,
                      )),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FavPage()));
                  }),
            ),
          ],
        ),
      );
    } else {
      final String path = album.docs.first['path'];
      return Center(
        child: Column(
          children: [
            SizedBox(
              width: 390,
              child: ListTile(
                  tileColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  title: const Text(name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.file(File(path), fit: BoxFit.cover)),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FavPage()));
                  }),
            ),
          ],
        ),
      );
    }
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
            Container(
              padding: const EdgeInsets.only(left: 13),
              alignment: Alignment.center,
              width: 400,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<Widget>(
                        future: displayTitle(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                        }),
                    RawMaterialButton(
                      constraints: const BoxConstraints(
                        minWidth: 20,
                      ),
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
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'TsukimiRounded'),
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
                                      final albumName =
                                          _albumNameController.text;
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 25),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: user.collection('Favourites').get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder<Widget>(
                        future: buildFavTile(snapshot
                            .data!), // Pass the document snapshot to buildListTile
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                        });
                  } else {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                }),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                  stream: user.collection("Outfit Albums").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
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
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'TsukimiRounded'),
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
                                                child: const Text('Delete',
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
                              child: FutureBuilder<Widget>(
                                future: buildListTile(album),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!;
                                  } else {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }
                                },
                              ),
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
