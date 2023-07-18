import 'package:flutter/material.dart';
import 'package:thelazycloset/album.dart';
import 'package:thelazycloset/album_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'albumdb.dart';
import 'package:flutter/cupertino.dart';

class ClosetPage extends StatefulWidget {
  const ClosetPage({super.key});

  @override
  State<ClosetPage> createState() {
    return _ClosetPageState();
  }
}

class _ClosetPageState extends State<ClosetPage> {
  List<Album> albums = [];
  bool isLoading = false;

  final TextEditingController _newAlbumController = TextEditingController();
  final TextEditingController _renameAlbumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshAlbums();
  }

  Future refreshAlbums() async {
    setState(() => isLoading = true);
    albums = await AlbumDB.instance.readAllAlbums();
    setState(() => isLoading = false);
  }

  Future _createAlbum() async {
    final albumName = _newAlbumController.text;
    if (albumName.isNotEmpty) {
      final album = await AlbumDB.instance.create(Album(
        name: albumName,
        images: [],
      ));
      setState(() {
        albums.add(album);
      });
    }
    _newAlbumController.clear();
  }

  /* @override
  void dispose() {
    _newAlbumController.dispose();
    _renameAlbumController.dispose();
    AlbumDB.instance.close();
    super.dispose();
  }
*/
  Future _renameAlbum(Album album) async {
    final newName = _renameAlbumController.text;
    if (newName.isNotEmpty) {
      final updatedAlbum =
          Album(id: album.id, name: newName, images: album.images);
      await AlbumDB.instance.update(updatedAlbum);
      setState(() {
        album.name = newName;
      });
    }
    _renameAlbumController.clear();
  }

  Future _onDismissed(int index) async {
    final idDelete = albums[index].id!;
    await AlbumDB.instance.delete(idDelete);
    setState(() => albums.removeAt(index));
  }

  Widget buildListTile(Album album) => Center(
        child: Column(
          children: [
            SizedBox(
              width: 360,
              child: ListTile(
                  tileColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 208, 207, 207)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(album.name,
                      style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  leading: album.images.isEmpty
                      ? const Icon(
                          color: Color.fromARGB(255, 170, 169, 169),
                          Icons.image,
                          size: 40,
                        )
                      : Image.memory(base64Decode(album.images.first)),

                  /// Image.file(File(album.images.first)),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PhotoAlbumScreen(id: album.id!)));
                    refreshAlbums();
                  }),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Text("TheLazyCloset",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 25),
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
                                controller: _newAlbumController,
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
                                  onPressed: () async => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text('Create',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  onPressed: () async {
                                    _createAlbum();
                                    Navigator.pop(context);
                                    refreshAlbums();
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
              child: ListView.separated(
                itemCount: albums.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final album = albums[index];
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
                            backgroundColor:
                                const Color.fromARGB(255, 238, 233, 192),
                            onPressed: (context) async => {
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      controller: _newAlbumController,
                                      placeholder: 'New album name',
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
                                        onPressed: () async =>
                                            Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text('Rename',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onPressed: () async {
                                          _renameAlbum(album);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            },
                          ),
                          SlidableAction(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            backgroundColor:
                                const Color.fromARGB(255, 213, 159, 156),
                            icon: Icons.delete,
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
                                                fontWeight: FontWeight.bold,
                                              )),
                                          onPressed: () {
                                            Slidable.of(context)?.close();
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
                                          _onDismissed(index);
                                          Navigator.pop(context);
                                          refreshAlbums();
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
                      child: buildListTile(album));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
