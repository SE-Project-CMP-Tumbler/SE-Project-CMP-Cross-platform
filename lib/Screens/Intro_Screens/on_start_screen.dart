import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gif_view/gif_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumbler/Constants/colors.dart';
import 'package:tumbler/Constants/ui_styles.dart';
import 'package:tumbler/Screens/Log_In_Screens/log_in.dart';
import 'package:tumbler/Screens/Sign_Up_Screens/get_age.dart';
import 'package:tumbler/Widgets/carousel_item_on_start.dart';

class OnStart extends StatefulWidget {
  const OnStart({Key? key}) : super(key: key);

  @override
  _OnStartState createState() => _OnStartState();
}

class _OnStartState extends State<OnStart> with TickerProviderStateMixin {
  int _currentPage = 0;
  bool isClicked = false;
  int _currentButtonSet = 1;
  bool _hideButtonSet1 = false;
  bool _hideButtonSet2 = true;
  bool _hideButtonSet3 = true;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    //TODO:: change this if we decided to build ios app
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return WillPopScope(
      onWillPop: () {
        setState(() {
          _hideButtonSet1 = false;
          isClicked = false;
          _currentButtonSet = 1;
        });
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appBackgroundColor,
          body: Stack(
            alignment: Alignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  'Where your interests connect you with your people',
                  textScaleFactor: 1.7,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'favoritPro',
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              CarouselSlider(
                  items: [
                    CarouselItemBuilder(
                      width: _width,
                      height: _height,
                      imageUrl: 'assets/images/intro_1.gif',
                      title: 'Explore\nmind-blowing stuff.',
                      poster: 'Posted by erik-blad',
                    ),
                    CarouselItemBuilder(
                      width: _width,
                      height: _height,
                      imageUrl: isAndroid
                          ? 'assets/images/intro_2.gif'
                          : 'assets/images/intro_2_delayed.gif',
                      title: 'Follow Tumblers that\nspark your interests.',
                      poster: 'Posted by bleedgfx',
                      gifView: isAndroid,
                    ),
                    CarouselItemBuilder(
                      width: _width,
                      height: _height,
                      imageUrl: 'assets/images/intro_3.jpg',
                      title: 'Customize how you\nlook, be who you\nwant.',
                      poster: 'Posted by danluvisiart',
                    ),
                    CarouselItemBuilder(
                      width: _width,
                      height: _height,
                      imageUrl: 'assets/images/intro_4.jpg',
                      title: 'Post anything:\nText, GIFs, music,\nwhatever.',
                      poster: 'Posted by witchoria',
                    ),
                    CarouselItemBuilder(
                      width: _width,
                      height: _height,
                      imageUrl: 'assets/images/intro_5.gif',
                      title: 'Welcome to Tumbler.\nNow push the button.',
                      poster: 'Posted by skiphursh',
                    )
                  ],
                  options: CarouselOptions(
                    onPageChanged: (int page, reason) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    viewportFraction: 1.0,
                    height: _height,
                    autoPlay: true,
                    autoPlayInterval: const Duration(milliseconds: 3500),
                    pauseAutoPlayOnManualNavigate: true,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Center(
                              child: Image.asset(
                            'assets/images/logo.png',
                            width: (_width / 2) - 10,
                          )))),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildPageIndicator(0),
                            const SizedBox(
                              width: 10.0,
                            ),
                            buildPageIndicator(1),
                            const SizedBox(
                              width: 10.0,
                            ),
                            buildPageIndicator(2),
                            const SizedBox(
                              width: 10.0,
                            ),
                            buildPageIndicator(3),
                            const SizedBox(
                              width: 10.0,
                            ),
                            buildPageIndicator(4),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(),
                      ),
                    ],
                  )),
                ],
              ),
              Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 3,
                          child: Stack(alignment: Alignment.center, children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                              left: 0,
                              right: 0,
                              bottom: (_currentButtonSet == 1)
                                  ? _height / 6
                                  : _height / 3,
                              onEnd: () {
                                if (_currentButtonSet != 1) {
                                  setState(() {
                                    _hideButtonSet1 = true;
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                height: (_hideButtonSet1) ? 0 : null,
                                duration: const Duration(milliseconds: 300),
                                child: AnimatedOpacity(
                                  opacity: (_currentButtonSet == 1) ? 1 : 0,
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 500),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _width / 7,
                                                vertical: 2),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_currentButtonSet == 1) {
                                                    setState(() {
                                                      isClicked = true;
                                                      _currentButtonSet =
                                                          2; //signUp options
                                                      _hideButtonSet2 = false;
                                                    });
                                                    //logic of the function here

                                                  }
                                                },
                                                child: const Text(
                                                  'Sign up',
                                                  textScaleFactor: 1.3,
                                                ),
                                                style: onStartButtonStyle),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _width / 7,
                                                vertical: 2),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_currentButtonSet == 1) {
                                                    setState(() {
                                                      _currentButtonSet =
                                                          3; //login options
                                                      _hideButtonSet3 = false;
                                                    });
                                                    //logic of the function here
                                                  }
                                                },
                                                child: const Text(
                                                  'Log in',
                                                  textScaleFactor: 1.3,
                                                ),
                                                style: onStartButtonStyle),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //signUp options
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              left: 0,
                              right: 0,
                              bottom:
                                  (_currentButtonSet == 2) ? _height / 6 : -100,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: _hideButtonSet2 ? 0 : null,
                                child: AnimatedOpacity(
                                  opacity: (_currentButtonSet == 2) ? 1 : 0,
                                  curve: Curves.easeInOutCubic,
                                  duration: const Duration(milliseconds: 500),
                                  onEnd: () {
                                    if (_currentButtonSet != 2) {
                                      setState(() {
                                        _hideButtonSet2 = true;
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _width / 7,
                                                vertical: 2),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_currentButtonSet == 2) {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    GetAge()));
                                                  }
                                                },
                                                child: const Text(
                                                  'Sign up with email',
                                                  textScaleFactor: 1.3,
                                                ),
                                                style: onStartButtonStyle),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _width / 7,
                                                vertical: 2),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_currentButtonSet == 2) {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    GetAge()));
                                                  }
                                                },
                                                child: const Text(
                                                  'Sign up with Google',
                                                  textScaleFactor: 1.3,
                                                ),
                                                style: onStartButtonStyle),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //Login options
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              left: 0,
                              right: 0,
                              bottom:
                                  (_currentButtonSet == 3) ? _height / 6 : -100,
                              onEnd: () {
                                if (_currentButtonSet != 3) {
                                  setState(() {
                                    _hideButtonSet3 = true;
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: _hideButtonSet3 ? 0 : null,
                                child: AnimatedOpacity(
                                  opacity: (_currentButtonSet == 3) ? 1 : 0,
                                  curve: Curves.easeInOutCubic,
                                  duration: const Duration(milliseconds: 500),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _width / 7,
                                                vertical: 2),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_currentButtonSet == 3) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LogIN()));
                                                }
                                              },
                                              child: const Text(
                                                'Log in with email',
                                                textScaleFactor: 1.3,
                                              ),
                                              style: onStartButtonStyle,
                                            ),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _width / 7,
                                                vertical: 2),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_currentButtonSet == 3) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LogIN()));
                                                }
                                              },
                                              child: const Text(
                                                'Log in with Google',
                                                textScaleFactor: 1.3,
                                              ),
                                              style: onStartButtonStyle,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack buildPageIndicator(int page) {
    return Stack(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.grey),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
              width: (_currentPage == page) ? 10 : 0.0,
              height: (_currentPage == page) ? 10 : 0.0,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular((_currentPage == page) ? 10 : 1.0),
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}


