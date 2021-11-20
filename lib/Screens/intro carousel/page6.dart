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

class Page6 extends StatelessWidget {
  const Page6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
        backgroundColor: Colors.lightBlue[800],
        body: Container(
          margin: EdgeInsets.only(
              top: screenAvailHeight * 0.1, left: screenAvailWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createText("Explore and", Colors.black, 50),
              SizedBox(
                height: screenAvailHeight * 0.01,
              ),
              createText("discover", Colors.black, 50),
              SizedBox(
                height: screenAvailHeight * 0.01,
              ),
              createText("new", Colors.black, 50),
              SizedBox(
                height: screenAvailHeight * 0.01,
              ),
              createText("interests.", Colors.black, 50),
              SizedBox(
                height: screenAvailHeight * 0.01,
              ),
              createText("Find your", Colors.black, 50),
              SizedBox(
                height: screenAvailHeight * 0.01,
              ),
              createText("people...", Colors.black, 50),
            ],
          ),
        ));
  }
}
