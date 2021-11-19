import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        //margin: EdgeInsets.all(50),
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 120, 20, 150),
          child: Stack(
            children: [
              SizedBox(
                width: 500,
                height: 400,
                child: Image.asset("assets/Page2Image.png"),
              ),
              Positioned(
                bottom: -70,
                left: 20,
                child: Container(
                  child: Column(
                    children: const [
                      Text(
                        "express",
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontFamily: "UnvEx"),
                      ),
                      Text("yourself",
                          style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              fontFamily: "UnvEx"))
                    ],
                  ),
                ),
              )
            ],
            overflow: Overflow.visible,
          ),
        ),
      ),
    );
  }
}