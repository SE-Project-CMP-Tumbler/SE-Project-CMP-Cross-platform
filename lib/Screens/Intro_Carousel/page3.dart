import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text_style.dart";

/// Third Page of Intro Carousel
class Page3 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final double screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0.25 * screenAvailHeight,
            right: 25,
            child: Image.asset(
              "assets/images/women.png",
              width: screenAvailWidth * 0.7,
            ),
          ),
          Positioned(
            top: screenAvailHeight * 0.15,
            left: 30,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  child: customText("discover", Colors.white, 54),
                ),
                SizedBox(
                  height: screenAvailHeight * 0.01,
                ),
                FittedBox(child: customText("your", Colors.white, 54)),
                SizedBox(
                  height: screenAvailHeight * 0.01,
                ),
                FittedBox(child: customText("community", Colors.white, 54))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
