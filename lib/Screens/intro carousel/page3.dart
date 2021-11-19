import 'package:flutter/material.dart';

Widget createText(String txt, Color chosenColor, double fontSize) {
  return Text(
    txt,
    style: TextStyle(
        color: chosenColor,
        fontSize: fontSize,
        fontFamily: "sans-serif",
        fontWeight: FontWeight.normal),
  );
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
        child: Container(
          width: screenAvailWidth * 0.9,
          height: screenAvailHeight * 0.8,
          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    "assets/Page3Image.jpg",
                    height: screenAvailHeight * 0.55,
                  )),
              Positioned(
                bottom: screenAvailHeight * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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