import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text_style.dart";

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
            customText("Explore and", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("discover", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("new", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("interests.", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("Find your", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("people ...", Colors.black, 54),
          ],
        ),
      ),
    );
  }
}
