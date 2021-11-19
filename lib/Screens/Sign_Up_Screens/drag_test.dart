import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/Constants/colors.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  double dxStart = 30;
  double dyStart = 40;
  double dx = 30;
  double dy = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Drag"),
        backgroundColor: appBackgroundColor,
      ),
      body: Container(
        color: appBackgroundColor,
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            AnimatedPositioned(
              bottom: dy,
              right: dx,
              duration: const Duration(milliseconds: 200),
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.ten_k_outlined, color: Colors.white),
              ),
            ),
            AnimatedPositioned(
              bottom: dy,
              right: dx,
              duration: const Duration(milliseconds: 300),
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.ten_k_outlined, color: Colors.white),
              ),
            ),
            AnimatedPositioned(
              bottom: dy,
              right: dx,
              duration: const Duration(milliseconds: 400),
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eighteen_mp, color: Colors.white),
              ),
            ),
            AnimatedPositioned(
              bottom: dy,
              right: dx,
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eighteen_mp, color: Colors.white),
              ),
            ),
            AnimatedPositioned(
              bottom: dy,
              right: dx,
              duration: const Duration(milliseconds: 600),
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eighteen_mp, color: Colors.white),
              ),
            ),
            AnimatedPositioned(
              bottom: dy,
              right: dx,
              duration: const Duration(milliseconds: 700),
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eighteen_mp, color: Colors.white),
              ),
            ),
            Positioned(
              right: dxStart,
              bottom: dyStart,
              child: Draggable(
                onDragUpdate: (d) {
                  setState(() {
                    dx -= d.delta.dx;
                    dy -= d.delta.dy;
                  });
                },
                onDraggableCanceled: (v, d) {
                  setState(() {
                    dx = dxStart;
                    dy = dyStart;
                  });
                },
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                  onPressed: () {},
                ),
                feedback: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                  onPressed: () {},
                ),
                childWhenDragging: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
