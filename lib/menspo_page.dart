import 'package:flutter/material.dart';
import 'enlarge_page.dart';
import 'womenspo_page.dart';

List<ImageDetails> _images = [
  ImageDetails(
    imagePath: 'images/menspo1.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo2.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo3.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo4.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo5.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo6.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo7.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo8.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo9.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo10.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo11.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo12.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo13.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo14.jpg',
  ),
  ImageDetails(
    imagePath: 'images/menspo15.jpg',
  ),
];

class MenspoPage extends StatelessWidget {
  const MenspoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const ImageIcon(
                      AssetImage('images/backarrow.png'),
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 115),
                const ImageIcon(
                  AssetImage('images/hanger.png'),
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnlargePage(
                              imagePath: _images[index].imagePath,
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(_images[index].imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _images.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
