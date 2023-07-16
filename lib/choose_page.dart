import 'package:flutter/material.dart';
import 'inspo_page.dart';

InspoPage women = const InspoPage(displayImages: [
  'images/inspo1.jpg',
  'images/inspo2.jpg',
  'images/inspo3.jpg',
  'images/inspo4.jpg',
  'images/inspo5.jpg',
  'images/inspo6.jpg',
  'images/inspo7.jpg',
  'images/inspo8.jpg',
  'images/inspo9.jpg',
  'images/inspo10.jpg',
  'images/inspo11.jpg',
  'images/inspo12.jpg',
  'images/inspo13.jpg',
  'images/inspo14.jpg',
  'images/inspo15.jpg',
]);

InspoPage men = const InspoPage(displayImages: [
  'images/menspo1.jpg',
  'images/menspo2.jpg',
  'images/menspo3.jpg',
  'images/menspo4.jpg',
  'images/menspo5.jpg',
  'images/menspo6.jpg',
  'images/menspo7.jpg',
  'images/menspo8.jpg',
  'images/menspo9.jpg',
  'images/menspo10.jpg',
  'images/menspo11.jpg',
  'images/menspo12.jpg',
  'images/menspo13.jpg',
  'images/menspo14.jpg',
  'images/menspo15.jpg',
]);

class ChoosePage extends StatelessWidget {
  const ChoosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 70,
            ),
            const ImageIcon(
              AssetImage('images/hanger.png'),
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'TheLazyCloset',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 90,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Find Inspiration',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ignore: sized_box_for_whitespace
                Container(
                  width: 300,
                  height: 70,
                  child: RawMaterialButton(
                    fillColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => women,
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: const Text(
                      'Women',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ignore: sized_box_for_whitespace
                Container(
                  width: 300,
                  height: 70,
                  child: RawMaterialButton(
                    fillColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => men,
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: const Text(
                      'Men',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
