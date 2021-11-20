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
      backgroundColor:  Colors.transparent,
      body: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(top:screenAvailHeight*0.23),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Image.asset('assets/images/cat.png',width: screenAvailWidth*0.75,),
                  ),
              Positioned(
                  top: screenAvailHeight*0.27,
                  left: screenAvailWidth*0.1,
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
