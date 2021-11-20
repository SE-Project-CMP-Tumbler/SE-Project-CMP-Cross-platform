import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(top: 0.2*_height, left: 0.085*_width),
        child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "tumblr",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      fontFamily: "ClabBold"),
                ),
                Text(
                  "is a place",
                  style: TextStyle(color: Colors.black, fontSize: 50),
                ),
                Text(
                  "to ...",
                  style: TextStyle(color: Colors.black, fontSize: 50),
                ),
              ],
            )),
      ),
    );
  }
}
