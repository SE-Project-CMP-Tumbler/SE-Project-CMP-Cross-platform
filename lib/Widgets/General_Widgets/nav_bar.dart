import "package:flutter/material.dart";

///Facilitates navigation to the main screens in the application.
class NavBar extends StatelessWidget {
  /// Constructor
  const NavBar(this.selectedIndex);

  /// Current Index for the Selected page
  final int selectedIndex;

  /// Called when the user tap on any button in
  /// the navigation bar to redirect him to the screen desired.
  void onItemTapped(final int index) {
    //if index=0 go to home route
    // if index=1  go to search
    // if index=2 go to .....
  }

  @override
  Widget build(final BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
          backgroundColor: Color.fromRGBO(0, 25, 53, 1),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_emotions),
          label: "emo",
          backgroundColor: Colors.purple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "person",
          backgroundColor: Colors.green,
        ),
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
