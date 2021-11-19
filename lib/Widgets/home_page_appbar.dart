import 'package:flutter/material.dart';

enum HomeSection {
  following,
  stuffForYou,
}

class HomePageAppBar extends StatelessWidget {
  Function changeSection;
  Enum section;

  HomePageAppBar({Key? key, required this.changeSection, required this.section})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      stretch: true,
      snap: true,
      backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
      leading: Image.asset(
        'assets/images/tumblr-24.png',
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          TextButton(
              onPressed: () => changeSection(),
              child: Text("Following",
                  style: TextStyle(
                      color: (section.index == HomeSection.following.index)
                          ? Colors.blue
                          : Colors.grey,
                      fontSize: 17))),
          TextButton(
              onPressed: () => changeSection(),
              child: Text("Stuff for you",
                  style: TextStyle(
                      color: (section.index == HomeSection.stuffForYou.index)
                          ? Colors.blue
                          : Colors.grey,
                      fontSize: 17)))
        ],
      ),
    );
  }
}
