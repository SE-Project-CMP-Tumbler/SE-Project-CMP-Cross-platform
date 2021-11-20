import "package:flutter/material.dart";
import "package:tumbler/Widgets/Intro_Carousel/text.dart";

/// Fourth Page in Intro Carousel
class Page4 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final double screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(top: screenAvailHeight * 0.23),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset(
                  "assets/images/cat.png",
                  width: screenAvailWidth * 0.75,
                ),
              ),
              Positioned(
                top: screenAvailHeight * 0.27,
                left: screenAvailWidth * 0.1,
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
