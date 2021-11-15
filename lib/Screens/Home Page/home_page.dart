import 'dart:ui';

import 'package:flutter/material.dart';
import '../../Widgets/general_widgets/nav_bar.dart';
import '../../Widgets/Post/post_overview.dart';

enum HomeSection {
  following,
  stuffForYou,
}

void showEditPostBottomSheet(BuildContext ctx) {
  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: ctx,
    builder: (_) {
      return Container(
        height: 200,
        color: Colors.black38,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {},
                child: const Text("This particular post isn't for me")),
            TextButton(
                onPressed: () {},
                child: const Text("Copy post")),
            TextButton(
                onPressed: () {},
                child: const Text("Report post")),
            TextButton(
                onPressed: () {},
                child: const Text("hmmmmmmmmmm...")),
          ],
        ),
      );
    },
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navBarIndex = 0;
  Enum section = HomeSection.following;

  void changeSection() {
    setState(() {
      if (section == HomeSection.following) {
        section = HomeSection.stuffForYou;
      } else {
        section = HomeSection.following;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.black87,
            leading: Image.asset(
              'assets/images/tumblr-24.png',
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                TextButton(
                    onPressed: changeSection,
                    child: Text("Following",
                        style: TextStyle(
                            color: (section == HomeSection.following)
                                ? Colors.blue
                                : Colors.grey,
                            fontSize: 17))),
                TextButton(
                    onPressed: changeSection,
                    child: Text("Stuff for you",
                        style: TextStyle(
                            color: (section == HomeSection.stuffForYou)
                                ? Colors.blue
                                : Colors.grey,
                            fontSize: 17)))
              ],
            ),
          ),
        ],
        body: Column(
          children: [
            Expanded(
              child: ListView(children: [
                PostOutView(
                  showEditPostBottomSheet: showEditPostBottomSheet,
                ),
               const Divider(
                  color: Colors.black87,
                  height: 5,
                ),
                PostOutView(
                  showEditPostBottomSheet: showEditPostBottomSheet,
                ),
               const Divider(
                  color: Colors.black87,
                  height: 5,
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(_navBarIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.mode_edit_outline_outlined,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
