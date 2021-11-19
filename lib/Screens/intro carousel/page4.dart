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

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenAvailHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    final screenAvailWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: Center(
        child: Container(
          height: screenAvailHeight * 0.7,
          width: screenAvailWidth * 0.9,
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    "assets/Cat-Photo.jpg",
                    width: screenAvailWidth * 0.8,
                    scale: 1,
                  )),
              Positioned(
                  bottom: -2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}