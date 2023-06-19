import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'closet_page.dart';
import 'thoughts_page.dart';
import 'choose_page.dart';
import 'try_page.dart';

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
    const TryPage(),
    const ClosetPage(),
    const ThoughtsPage(),
    const ChoosePage(),
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
            color: Colors.white,
            activeColor: const Color.fromARGB(255, 104, 104, 104),
            tabs: const [
              GButton(icon: Icons.home),
              GButton(icon: Icons.collections),
              GButton(icon: Icons.favorite),
              GButton(icon: Icons.lightbulb),
            ],
          ),
        ),
      ),
    );
  }
}
