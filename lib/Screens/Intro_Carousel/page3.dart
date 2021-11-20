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
      backgroundColor:  Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0.25*screenAvailHeight,
            right: 25,
            child: Image.asset('assets/images/women.png',width: screenAvailWidth*0.7,),
          ),
          Positioned(
            top:  screenAvailHeight*0.15,
            left: 30,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: createText("discover", Colors.white, 54),
                ),
                SizedBox(
                  height: screenAvailHeight * 0.01,
                ),
                FittedBox(child: createText("your", Colors.white, 54)),
                SizedBox(
                  height: screenAvailHeight * 0.01,
                ),
                FittedBox(child: createText("community", Colors.white, 54))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
