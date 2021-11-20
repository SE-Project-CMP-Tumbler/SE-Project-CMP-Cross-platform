import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text.dart";

/// Fourth Page in IntroCarousel
class Page4 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final double screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: SizedBox(
          height: screenAvailHeight * 0.7,
          width: screenAvailWidth * 0.9,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  "assets/Cat-Photo.jpg",
                  width: screenAvailWidth * 0.8,
                  scale: 1,
                ),
              ),
              Positioned(
                bottom: -2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    createText("and", Colors.black, 45),
                    SizedBox(
                      height: screenAvailHeight * 0.01,
                    ),
                    createText("explore", Colors.black, 45),
                    SizedBox(
                      height: screenAvailHeight * 0.01,
                    ),
                    createText("what you", Colors.black, 45),
                    SizedBox(
                      height: screenAvailHeight * 0.01,
                    ),
                    createText("love!", Colors.black, 45),
                    SizedBox(
                      height: screenAvailHeight * 0.01,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
