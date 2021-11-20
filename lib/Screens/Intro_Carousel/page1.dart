import "package:flutter/material.dart";

/// First Page in IntroCarousel
class Page1 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        margin: const EdgeInsets.fromLTRB(30, 210, 60, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              "tumblr",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 50,
                fontFamily: "ClabBold",
              ),
            ),
            Text(
              "is a place",
              style: TextStyle(color: Colors.black, fontSize: 50),
            ),
            Text(
              "to ...",
              style: TextStyle(color: Colors.black, fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}
