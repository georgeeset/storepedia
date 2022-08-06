import 'package:flutter/material.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Frequently Used',
        ),
      ],
      // currentIndex: _selectedIndex,
      // selectedItemColor: Colors.amber[800],
      // onTap: _onItemTapped,
    );
  }
}
