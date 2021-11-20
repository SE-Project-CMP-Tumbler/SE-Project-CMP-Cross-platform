import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tumbler/Constants/colors.dart';

class DraggableFloatingActionButton extends StatefulWidget {
  final Widget child;
  final Offset initialOffset;
  final VoidCallback onPressed;
  final GlobalKey parentKey;
  final Duration duration;

  const DraggableFloatingActionButton(
      {required this.child,
      required this.initialOffset,
      required this.onPressed,
      required this.parentKey,
      required this.duration});

  @override
  State<StatefulWidget> createState() => _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  final GlobalKey _key = GlobalKey();

  bool _isDragging = false;
  late Offset _offset;
  late Offset _minOffset;
  late Offset _maxOffset;

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset;

    WidgetsBinding.instance?.addPostFrameCallback(_setBoundary);
  }

  void _setBoundary(_) {
    final RenderBox parentRenderBox =
        widget.parentKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;

    try {
      final Size parentSize = parentRenderBox.size;
      final Size size = renderBox.size;

      setState(() {
        _minOffset = const Offset(0, 0);
        _maxOffset = Offset(
            parentSize.width - size.width, parentSize.height - size.height);
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    double newOffsetX = _offset.dx + pointerMoveEvent.delta.dx;
    double newOffsetY = _offset.dy + pointerMoveEvent.delta.dy;

    if (newOffsetX < _minOffset.dx) {
      newOffsetX = _minOffset.dx;
    } else if (newOffsetX > _maxOffset.dx) {
      newOffsetX = _maxOffset.dx;
    }

    if (newOffsetY < _minOffset.dy) {
      newOffsetY = _minOffset.dy;
    } else if (newOffsetY > _maxOffset.dy) {
      newOffsetY = _maxOffset.dy;
    }

    setState(() {
      _offset = Offset(newOffsetX, newOffsetY);
    });
  }

  void _resetPosition() {
    double newOffsetX = widget.initialOffset.dx;
    double newOffsetY = widget.initialOffset.dy;

    if (newOffsetX < _minOffset.dx) {
      newOffsetX = _minOffset.dx;
    } else if (newOffsetX > _maxOffset.dx) {
      newOffsetX = _maxOffset.dx;
    }

    if (newOffsetY < _minOffset.dy) {
      newOffsetY = _minOffset.dy;
    } else if (newOffsetY > _maxOffset.dy) {
      newOffsetY = _maxOffset.dy;
    }

    setState(() {
      _offset = Offset(newOffsetX, newOffsetY);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      buildAnimatedPositioned(
          Colors.deepOrange,
          1,
          Image.asset(
            'assets/images/quote.png',
            color: navy,
            width: 25.0,
          )),
      buildAnimatedPositioned(
          Colors.white,
          2,
          Image.asset(
            'assets/images/capital_letter.png',
            color: navy,
            width: 25.0,
          )),
      buildAnimatedPositioned(
          Colors.pink,
          3,
          Icon(
            CupertinoIcons.headphones,
            color: navy,
            size: 30,
          )),
      buildAnimatedPositioned(
          Colors.deepPurple,
          4,
          Icon(
            CupertinoIcons.videocam_fill,
            color: navy,
            size: 30,
          )),
      buildAnimatedPositioned(
          floatingButtonColor,
          5,
          Center(
            child: Text(
              'hi!',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 22.0, color: navy),
            ),
          )),
      buildAnimatedPositioned(
          Colors.green,
          6,
          Icon(
            Icons.all_inclusive_outlined,
            color: navy,
            size: 25,
          )),
      buildAnimatedPositioned(
          Colors.yellow,
          7,
          Icon(
            Icons.gif_outlined,
            color: navy,
            size: 30,
          )),
      buildAnimatedPositioned(
          Colors.red,
          8,
          Icon(
            CupertinoIcons.photo_camera_solid,
            color: navy,
          )),
      AnimatedPositioned(
        curve: Curves.easeOutCubic,
        duration: Duration(milliseconds: widget.duration.inMilliseconds),
        left: _offset.dx,
        top: _offset.dy,
        child: Listener(
          onPointerSignal: (PointerSignalEvent pointerSignalEvent) {},
          onPointerMove: (PointerMoveEvent pointerMoveEvent) {
            _updatePosition(pointerMoveEvent);
            setState(() {
              _isDragging = true;
            });
          },
          onPointerUp: (PointerUpEvent pointerUpEvent) {
            if (_isDragging) {
              _resetPosition();
              setState(() {
                _isDragging = false;
              });
            } else {}
          },
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            key: _key,
            child: widget.child,
            backgroundColor: floatingButtonColor,
          ),
        ),
      ),
    ]);
  }

  AnimatedPositioned buildAnimatedPositioned(
      Color bgColor, int index, Widget child) {
    return AnimatedPositioned(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(
          milliseconds: (index + 5) * (index + 1) * 60 - index * 300 + 50),
      left: _offset.dx,
      top: _offset.dy,
      child: FloatingActionButton(
        elevation: 0.0,
        onPressed: widget.onPressed,
        child: child,
        foregroundColor: Colors.black,
        backgroundColor: bgColor,
      ),
    );
  }
}
