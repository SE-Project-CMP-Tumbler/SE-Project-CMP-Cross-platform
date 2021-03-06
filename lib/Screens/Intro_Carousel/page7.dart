import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text_style.dart";

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
            customText("follow them", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("and fill your", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("dashboard", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("with all the", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("things you", Colors.black, 54),
            SizedBox(
              height: screenAvailHeight * 0.01,
            ),
            customText("love.", Colors.black, 54),
          ],
        ),
      ),
    );
  }
}
