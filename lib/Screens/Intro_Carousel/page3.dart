import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text.dart";

/// Third Page in IntroCarousel
class Page3 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final double screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
        child: SizedBox(
          width: screenAvailWidth * 0.9,
          height: screenAvailHeight * 0.8,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  "assets/Page3Image.jpg",
                  height: screenAvailHeight * 0.55,
                ),
              ),
              Positioned(
                bottom: screenAvailHeight * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                      child: createText("discover", Colors.white, 45),
                    ),
                    SizedBox(
                      height: screenAvailHeight * 0.01,
                    ),
                    FittedBox(child: createText("your", Colors.white, 45)),
                    SizedBox(
                      height: screenAvailHeight * 0.01,
                    ),
                    FittedBox(child: createText("community", Colors.white, 45))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
