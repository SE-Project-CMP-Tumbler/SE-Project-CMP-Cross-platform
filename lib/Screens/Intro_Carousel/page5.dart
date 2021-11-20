import "package:animator/animator.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

/// Fifth Page of Intro Carousel
class Page5 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 60,
            color: Colors.white,
            width: _width,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  "assets/images/intro_4.jpg",
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "therosygrail",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      const Text(
                        "Follow",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      Animator<double>(
                        tween: Tween<double>(begin: 4, end: 1),
                        curve: Curves.elasticOut,
                        resetAnimationOnRebuild: true,
                        cycles: 10,
                        repeats: 1,
                        duration: const Duration(seconds: 2),
                        builder: (
                          final _,
                          final AnimatorState<double> animationState,
                          final __,
                        ) =>
                            Transform.scale(
                          scale: animationState.value,
                          child: const Text(
                            "Follow",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/cat.png",
            width: _width,
            height: _height / 2,
            fit: BoxFit.cover,
          ),
          Container(
            height: 60,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "539 notes",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.location_fill,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      CupertinoIcons.chat_bubble,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Stack(
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.repeat,
                          color: Colors.grey.shade600,
                        ),
                        Animator<double>(
                          tween: Tween<double>(begin: 2, end: 1),
                          curve: Curves.elasticInOut,
                          resetAnimationOnRebuild: true,
                          cycles: 5,
                          repeats: 1,
                          duration: const Duration(seconds: 2),
                          builder: (
                            final _,
                            final AnimatorState<double> animationState,
                            final __,
                          ) =>
                              Transform.scale(
                            scale: animationState.value,
                            child: const Icon(
                              CupertinoIcons.repeat,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Stack(
                      children: <Widget>[
                        Icon(
                          Icons.favorite_border,
                          color: Colors.grey.shade600,
                        ),
                        Animator<double>(
                          tween: Tween<double>(begin: 4, end: 1),
                          curve: Curves.elasticOut,
                          resetAnimationOnRebuild: true,
                          cycles: 5,
                          repeats: 1,
                          duration: const Duration(seconds: 2),
                          builder: (
                            final _,
                            final AnimatorState<double> animationState,
                            final __,
                          ) =>
                              Transform.scale(
                            scale: animationState.value,
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
