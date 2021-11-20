import "package:flutter/material.dart";

/// Fifth Page in IntroCarousel
class Page5 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: SizedBox(
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              0.8,
          child: Image.asset(
            "assets/Cat-GIF.gif",
            scale: 0.5,
          ),
        ),
      ),
    );
  }
}
