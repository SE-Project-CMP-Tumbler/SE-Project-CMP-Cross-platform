import "package:flutter/material.dart";

/// First Page in Intro Carousel
class Page1 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(top: 0.2 * _height, left: 0.085 * _width),
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
