import "package:flutter/cupertino.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Screens/Add_Post/add_new_post.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";
import "package:tumbler/Widgets/draggable_floating_button.dart";

/// The Main Screen That Hold [HomePage],
/// Search Page, Activity Page, Profile Page
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // state variables "ll be defined here
  TabController? tabController;
  int selectedIndex = 0;
  double fButtonDx = 20;
  double fButtonDy = 20;
  final GlobalKey _parentKey = GlobalKey();

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded, size: 30),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble, size: 30),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person_solid,
              size: 30,
            ),
            label: "Profile",
          ),
        ],
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: navy,
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        onTap: onTabClicked,
      ),
      body: Stack(
        key: _parentKey,
        children: <Widget>[
          TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: <Widget>[
              const HomePage(),
              // TODO(Ziyad): Replace this with search page
              Container(
                color: appBackgroundColor,
                child: const Center(
                  child: Text("THIS IS SEARCH"),
                ),
              ),
              // TODO(Ziyad): Replace this with chat Page
              Container(
                color: appBackgroundColor,
                child: const Center(child: Text("THIS IS CHAT")),
              ),
              // TODO(Ziyad): Replace this with profile page
              ProfilePage(),
            ],
          ),
          if (selectedIndex == 0 || selectedIndex == 3)
            DraggableFloatingActionButton(
              duration: const Duration(milliseconds: 100),
              initialOffset: Offset(_width - 70, _height - 150),
              parentKey: _parentKey,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<AddPost>(
                    builder: (final BuildContext context) => AddPost(),
                  ),
                );
              },
              child: Image.asset(
                "assets/images/create_post.png",
                color: Colors.white,
                width: 25,
              ),
            )
        ],
      ),
    );
  }

  // All state functions will be declared here
  void onTabClicked(final int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }
}
