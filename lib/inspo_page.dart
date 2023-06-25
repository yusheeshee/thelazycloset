import 'package:flutter/material.dart';
import 'enlarge_page.dart';

class InspoPage extends StatelessWidget {
  final List<String> displayImages;
  const InspoPage({super.key, required this.displayImages});

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
                const SizedBox(width: 125),
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
                              imagePath: displayImages[index],
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(displayImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: displayImages.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
