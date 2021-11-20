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

class Page7 extends StatelessWidget {
  const Page7({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor:  Colors.transparent,
      body: Container(
          margin: EdgeInsets.only(
              left: screenAvailWidth * 0.08, top: screenAvailHeight * 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          )),
    );
  }
}
