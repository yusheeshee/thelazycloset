import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:thelazycloset/settings_page.dart';
import 'closet_page.dart';
import 'outfit_page.dart';
import 'choose_page.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const OutfitPage(),
    const ClosetPage(),
    const ChoosePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
          color: Color.fromARGB(255, 30, 30, 30),
        ))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: _navigateBottomBar,
            color: const Color.fromARGB(255, 104, 104, 104),
            activeColor: Colors.white,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: ' Outfits',
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              GButton(
                icon: Icons.collections,
                text: ' Closet',
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              GButton(
                icon: Icons.lightbulb,
                text: ' Inspo',
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              GButton(
                icon: Icons.settings,
                text: ' Settings',
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
