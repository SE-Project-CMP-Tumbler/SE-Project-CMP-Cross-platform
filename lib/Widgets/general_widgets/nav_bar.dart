import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  int selectedIndex = 0;
  NavBar(this.selectedIndex);

  void onItemTapped(int index) {
    //if index=0 go to home route
    // if index=1  go to search
    // if index=2 go to .....
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black87),
        BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
            backgroundColor: Colors.pink),
        BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions),
            label: 'emo',
            backgroundColor: Colors.purple),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'person',
            backgroundColor: Colors.green),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      onTap: onItemTapped,
      unselectedItemColor: Colors.grey,
      iconSize: 30,
      showSelectedLabels: false,
    );
  }
}
