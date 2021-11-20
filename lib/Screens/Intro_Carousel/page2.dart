import "package:flutter/material.dart";

/// Second Page in IntroCarousel
class Page2 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 120, 20, 150),
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: 500,
              height: 400,
              child: Image.asset("assets/Page2Image.png"),
            ),
            Positioned(
              bottom: -70,
              left: 20,
              child: Column(
                children: const <Widget>[
                  Text(
                    "express",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      fontFamily: "UnvEx",
                    ),
                  ),
                  Text(
                    "yourself",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      fontFamily: "UnvEx",
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
