import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FitsPage extends StatefulWidget {
  const FitsPage({super.key});
  @override
  State<FitsPage> createState() {
    return _FitsPageState();
  }
}

class _FitsPageState extends State<FitsPage> {
  List<Album> albums = [];

  Future<void> _createAlbum() async {
    final textController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        iconColor: Colors.black,
        title: Text('Create Album'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Album Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final albumName = textController.text;
              if (albumName.isNotEmpty) {
                setState(() {
                  albums.add(Album(name: albumName));
                });
              }
              Navigator.of(context).pop();
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectAdd(Album album) async {
    final pickedImage = ImagePicker();
    final pickedAlbum =
        await pickedImage.pickImage(source: ImageSource.gallery);
    if (pickedAlbum != null) {
      final imageBytes = await pickedAlbum.readAsBytes();
      setState(() {
        album.photos = List.from(album.photos)..add(MemoryImage(imageBytes));
      });
    }
  }

  Future<void> _renameAlbum(Album album) async {
    final textController = TextEditingController(text: album.name);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Album'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Album Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final albumName = textController.text;
              if (albumName.isNotEmpty) {
                setState(() {
                  album.name = albumName;
                });
              }
              Navigator.of(context).pop();
            },
            child: Text('Rename'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumItem(Album album) {
    return ExpansionTile(
      title: Text(album.name),
      children: [
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add Photo'),
          onTap: () => _selectAdd(album),
        ),
      ],
      leading: Icon(Icons.photo_album),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => _renameAlbum(album),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return _buildAlbumItem(album);
        },
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.black,
        onPressed: _createAlbum,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class Album {
  String name;
  List<ImageProvider> photos;

  Album({required this.name, this.photos = const []});
}
