import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text.dart";

/// Seventh Page of Intro Carousel
class Page7 extends StatelessWidget {
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
          left: screenAvailWidth * 0.08,
          top: screenAvailHeight * 0.15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            createText("follow them", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("and fill your", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("dashboard", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("with all the", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("things you", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            createText("love.", Colors.black, 54),
          ],
        ),
      ),
    );
  }
}
