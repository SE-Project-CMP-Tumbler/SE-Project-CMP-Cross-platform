// ignore_for_file: unnecessary_lambdas
import "package:flutter/material.dart";

/// HomeSection enum facilitates handling multiple sub-pages in home page.
enum HomeSection {
  /// Following Page
  following,

  /// Stuff for you Page
  stuffForYou,
}

///Users can use [HomePageAppBar] to navigate either
/// __following__ or __stuffForYou__ section.
class HomePageAppBar extends StatelessWidget {
  /// Constructor
  const HomePageAppBar({
    required final this.changeSection,
    required final this.section,
    final Key? key,
  }) : super(key: key);

  ///Called when the user tap on
  ///__following__ or __stuffForYou__ in home page appbar.
  final Function changeSection;

  ///Holds the current section the user in
  final Enum section;

  @override
  Widget build(final BuildContext context) {
    return SliverAppBar(
      floating: true,
      stretch: true,
      snap: true,
      backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
      leading: Image.asset(
        "assets/images/tumblr-24.png",
      ),
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          TextButton(
            onPressed: () => changeSection(),
            child: Text(
              "Following",
              style: TextStyle(
                color: (section.index == HomeSection.following.index)
                    ? Colors.blue
                    : Colors.grey,
                fontSize: 17,
              ),
            ),
          ),
          TextButton(
            onPressed: () => changeSection(),
            child: Text(
              "Stuff for you",
              style: TextStyle(
                color: (section.index == HomeSection.stuffForYou.index)
                    ? Colors.blue
                    : Colors.grey,
                fontSize: 17,
              ),
            ),
          )
        ],
      ),
    );
  }
}
