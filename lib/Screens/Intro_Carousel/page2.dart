import "package:flutter/material.dart";

/// Second page of Intro Carousel
class Page2 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0.08 * _height,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Image.asset(
                "assets/images/express_ys.png",
                height: _height / 2,
              ),
            ),
          ),
          Positioned(
            top: _height * 0.552,
            left: 30,
            child: Column(
              children: const <Widget>[
                Text(
                  "express",
                  style: TextStyle(fontSize: 54, fontFamily: "UnvEx"),
                ),
                Text(
                  "yourself",
                  style: TextStyle(fontSize: 54, fontFamily: "UnvEx"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
