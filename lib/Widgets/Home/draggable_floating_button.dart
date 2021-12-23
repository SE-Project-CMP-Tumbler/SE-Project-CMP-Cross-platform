import "package:flutter/cupertino.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";

/// Class for Draggable Floating Action Bar
class DraggableFloatingActionButton extends StatefulWidget {
  /// Constructor
  const DraggableFloatingActionButton({
    required final this.child,
    required final this.initialOffset,
    required final this.onPressed,
    required final this.parentKey,
    required final this.duration,
  });

  /// The Next Floating Action Bar
  final Widget child;

  /// Initial Offset of The Floating Action Bar
  final Offset initialOffset;

  /// On press function
  final VoidCallback onPressed;

  /// The Previous Floating Action Bar
  final GlobalKey parentKey;

  /// Duration of the Animation
  final Duration duration;

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

  void _setBoundary(final _) {
    final RenderBox parentRenderBox =
        widget.parentKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;

    try {
      final Size parentSize = parentRenderBox.size;
      final Size size = renderBox.size;

      setState(() {
        _minOffset = Offset.zero;
        _maxOffset = Offset(
          parentSize.width - size.width,
          parentSize.height - size.height,
        );
      });
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  void _updatePosition(final PointerMoveEvent pointerMoveEvent) {
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
  Widget build(final BuildContext context) {
    return Stack(
      children: <Widget>[
        buildAnimatedPositioned(
          Colors.deepOrange,
          1,
          Image.asset(
            "assets/images/quote.png",
            color: navy,
            width: 25,
          ),
        ),
        buildAnimatedPositioned(
          Colors.white,
          2,
          Image.asset(
            "assets/images/capital_letter.png",
            color: navy,
            width: 25,
          ),
        ),
        buildAnimatedPositioned(
          Colors.pink,
          3,
          Icon(
            CupertinoIcons.headphones,
            color: navy,
            size: 30,
          ),
        ),
        buildAnimatedPositioned(
          Colors.deepPurple,
          4,
          Icon(
            CupertinoIcons.videocam_fill,
            color: navy,
            size: 30,
          ),
        ),
        buildAnimatedPositioned(
          floatingButtonColor,
          5,
          Center(
            child: Text(
              "hi!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: navy,
              ),
            ),
          ),
        ),
        buildAnimatedPositioned(
          Colors.green,
          6,
          Icon(
            Icons.all_inclusive_outlined,
            color: navy,
            size: 25,
          ),
        ),
        buildAnimatedPositioned(
          Colors.yellow,
          7,
          Icon(
            Icons.gif_outlined,
            color: navy,
            size: 30,
          ),
        ),
        buildAnimatedPositioned(
          Colors.red,
          8,
          Icon(
            CupertinoIcons.photo_camera_solid,
            color: navy,
          ),
        ),
        AnimatedPositioned(
          curve: Curves.easeOutCubic,
          duration: Duration(milliseconds: widget.duration.inMilliseconds),
          left: _offset.dx,
          top: _offset.dy,
          child: Listener(
            onPointerSignal: (final PointerSignalEvent pointerSignalEvent) {},
            onPointerMove: (final PointerMoveEvent pointerMoveEvent) {
              _updatePosition(pointerMoveEvent);
              setState(() {
                _isDragging = true;
              });
            },
            onPointerUp: (final PointerUpEvent pointerUpEvent) {
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
              heroTag: "0",
              backgroundColor: floatingButtonColor,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }

  AnimatedPositioned buildAnimatedPositioned(
    final Color bgColor,
    final int index,
    final Widget child,
  ) {
    return AnimatedPositioned(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(
        milliseconds: (index + 5) * (index + 1) * 60 - index * 300 + 50,
      ),
      left: _offset.dx,
      top: _offset.dy,
      child: FloatingActionButton(
        heroTag: "${index + 1}",
        elevation: 0,
        onPressed: widget.onPressed,
        foregroundColor: Colors.black,
        backgroundColor: bgColor,
        child: child,
      ),
    );
  }
}
