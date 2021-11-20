import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text.dart";

/// Seventh Page in IntroCarousel
class Page7 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final double screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.greenAccent[700],
      body: Container(
        margin: EdgeInsets.only(
          left: screenAvailWidth * 0.05,
          top: screenAvailHeight * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            createText("follow them", Colors.black, 50),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("and fill your", Colors.black, 50),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("dashboard", Colors.black, 50),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("with all the", Colors.black, 50),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("things you", Colors.black, 50),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("love.", Colors.black, 50),
          ],
        ),
      ),
    );
  }
}
