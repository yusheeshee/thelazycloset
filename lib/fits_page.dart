import 'package:flutter/material.dart';
import 'package:thelazycloset/album.dart';
import 'package:thelazycloset/album_page.dart';

class FitsPage extends StatefulWidget {
  const FitsPage({super.key});
  @override
  State<FitsPage> createState() {
    return _FitsPageState();
  }
}

class _FitsPageState extends State<FitsPage> {
  List<Album> albums = [];

  final TextEditingController _newAlbumController = TextEditingController();
  final TextEditingController _renameAlbumController = TextEditingController();

  @override
  void dispose() {
    _newAlbumController.dispose();
    _renameAlbumController.dispose();
    super.dispose();
  }

  void _navigateToAlbumScreen(Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoAlbumScreen(album: album),
      ),
    );
  }

  void _addAlbum(String albumName) {
    setState(() {
      albums.add(Album(name: albumName, description: '', photos: []));
    });
    _newAlbumController.clear();
  }

  void _renameAlbum(int index, String newName) {
    setState(() {
      albums[index].name = newName;
    });
    _renameAlbumController.clear();
  }

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
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 25),
                const Text("My Outfits",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(width: 200),
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor:
                                const Color.fromARGB(255, 31, 30, 30),
                            title: const Text(
                              'Create Album',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            content: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _newAlbumController,
                              decoration: const InputDecoration(
                                  hintText: 'Album Name',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 172, 171, 171),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text('Add',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  _addAlbum(_newAlbumController.text);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.add, color: Colors.white, size: 25),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(width: 15),
                      TextButton(
                        child: Text(album.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20)),
                        onPressed: () => _navigateToAlbumScreen(album),
                      ),
                      SizedBox(width: 150),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  backgroundColor:
                                      const Color.fromARGB(255, 31, 30, 30),
                                  title: const Text(
                                    'Rename Album',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  content: TextField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: _renameAlbumController,
                                    decoration: const InputDecoration(
                                        hintText: 'New album name',
                                        hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 172, 171, 171),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('Rename',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      onPressed: () {
                                        _renameAlbum(
                                            index, _renameAlbumController.text);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
