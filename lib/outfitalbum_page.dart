import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'control_page.dart';
import 'image_page.dart';

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
      .collection('Outfit Albums');

  final user = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.email);

  @override
  void initState() {
    super.initState();
  }

  Future unFav(String id, String path) async {
    await albums
        .doc(widget.id)
        .collection('Images')
        .doc(id)
        .update({'fav': false});

    await user.collection('Favourites').doc(id).delete();

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

  Future addToFav(String id, String path) async {
    /*   QuerySnapshot querySnapshot = await albums.limit(1).get();
    final albumObj = querySnapshot.docs.first;
    albumObj.reference.collection('Images').where()
        .where('fav', isEqualTo: true)
        .get();
*/
/*final query = await albums.doc(widget.id).collection('Images').doc(id).get();
final alrFav = query['fav'];
    if (!alrFav) { */
    await albums
        .doc(widget.id)
        .collection('Images')
        .doc(id)
        .update({'fav': true});

    await user
        .collection('Favourites')
        .doc(id)
        .set({'albumid': widget.id, 'path': path});
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              title: const Text(
                'Added to Favourites',
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
          ] // Limit the maximum height of the cropped  // Limit the maximum height of the cropped image
          );
      if (croppedImage != null) {
        final imageFile = File(croppedImage.path);
        final String imagePath = imageFile.path;
        await albums
            .doc(widget.id)
            .collection('Images')
            .add({'path': imagePath, 'fav': false});
      }
    }
    return;
  }

  Future deleteImage(String id) async {
    await albums.doc(widget.id).collection('Images').doc(id).delete();
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String id) async {
    Navigator.pop(context);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          key: UniqueKey(), // Add a unique key to the dialog
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
          actions: [
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
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                deleteImage(
                    id); // Assuming you have defined deleteImage function
                Navigator.pop(
                    context); // Assuming you have defined refreshAlbum function
              },
            ),
          ],
        );
      },
    );
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ControlPage()));
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
                  stream: album.collection('Images').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          double availableWidth =
                              (MediaQuery.of(context).size.width) - 10;
                          final obj = snapshot.data!.docs[index];
                          final ImageProvider<Object> image =
                              Image.file(File(obj['path'])).image;
                          bool isFav = obj['fav'];
                          return CupertinoContextMenu(
                              previewBuilder: (context, animation, child) =>
                                  SizedBox.expand(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        image: DecorationImage(
                                          image: image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                              actions: [
                                CupertinoContextMenuAction(
                                  onPressed: () async {
                                    isFav
                                        ? await unFav(obj.id, obj['path'])
                                        : await addToFav(obj.id, obj['path']);
                                    Navigator.pop(context);
                                  },
                                  trailingIcon: isFav
                                      ? CupertinoIcons.heart_slash
                                      : CupertinoIcons.heart,
                                  child: isFav
                                      ? const Text('Remove from Favourites',
                                          style: TextStyle(
                                              fontFamily: 'TsukimiRounded',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600))
                                      : const Text('Add to Favourites',
                                          style: TextStyle(
                                              fontFamily: 'TsukimiRounded',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                ),
                                CupertinoContextMenuAction(
                                  onPressed: () async {
                                    await _showDeleteConfirmationDialog(
                                        context, obj.id);
                                  },
                                  isDestructiveAction: true,
                                  trailingIcon: CupertinoIcons.delete,
                                  child: const Text('Delete',
                                      style: TextStyle(
                                          fontFamily: 'TsukimiRounded',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                              child: isFav
                                  ? Stack(
                                      fit: StackFit.expand,
                                      alignment: Alignment.center,
                                      // Align the icon in the center of the image
                                      children: [
                                          Container(
                                              height: availableWidth,
                                              width: availableWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                image: DecorationImage(
                                                  image: image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: RawMaterialButton(
                                                onPressed: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImagePage(
                                                                image: image)),
                                                  );
                                                },
                                              )),
                                          const Positioned(
                                            top: 145,
                                            right: 10,
                                            child: Icon(
                                              Icons.favorite,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          )
                                        ])
                                  : Container(
                                      height: availableWidth,
                                      width: availableWidth,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        image: DecorationImage(
                                          image: image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: RawMaterialButton(
                                          onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImagePage(image: image)),
                                        );
                                      })));
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
