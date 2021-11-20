import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0.08*_height,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30.0),
              child: Image.asset('assets/images/express_ys.png',height: _height/2,),
            ),
          ),
          Positioned(
            top: _height*0.552,
            left: 30,
            child: Column(
              children: const [
                Text(
                  "express",
                  style: TextStyle(
                      fontSize: 54,
                      fontFamily: "UnvEx"),

                ),
                Text("yourself",
                    style: TextStyle(
                        fontSize: 54,
                        fontFamily: "UnvEx"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
