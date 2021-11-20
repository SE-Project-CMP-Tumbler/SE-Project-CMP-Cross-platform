import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text.dart";

/// sixth Page of Intro Carousel
class Page6 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final double screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(
          top: screenAvailHeight * 0.15,
          left: screenAvailWidth * 0.08,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            createText("Explore and", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("discover", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("new", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("interests.", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("Find your", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("people ...", Colors.black, 54),
          ],
        ),
      ),
    );
  }
}
