import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Screens/Sign_Up_Screens/Choose_Tag/tag_page.dart';
import '/Constants/colors.dart';
import '/Constants/ui_styles.dart';

class OnStart extends StatefulWidget {
  const OnStart({Key? key}) : super(key: key);

  @override
  _OnStartState createState() => _OnStartState();
}

class _OnStartState extends State<OnStart> with TickerProviderStateMixin {
  int _currentPage = 0;
  bool isClicked = false;
  int _currentButtonSet = 1;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        setState(() {
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
                      imageUrl: 'assets/images/intro_2.gif',
                      title: 'Follow Tumblrs that\nspark your interests.',
                      poster: 'Posted by bleedgfx',
                      gifView: true,
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
                              duration: const Duration(milliseconds: 400),
                              left: 0,
                              right: 0,
                              bottom: (_currentButtonSet == 1)
                                  ? _height / 6
                                  : _height / 3,
                              child: AnimatedOpacity(
                                opacity: (_currentButtonSet == 1) ? 1 : 0,
                                curve: Curves.easeInOutCubic,
                                duration: const Duration(milliseconds: 400),
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
                                                setState(() {
                                                  isClicked = true;
                                                  _currentButtonSet =
                                                      2; //signUp options
                                                });
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
                                                setState(() {
                                                  _currentButtonSet =
                                                      3; //login options
                                                });
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
                            //signUp options
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              left: 0,
                              right: 0,
                              bottom:
                                  (_currentButtonSet == 2) ? _height / 6 : 0,
                              child: AnimatedOpacity(
                                opacity: (_currentButtonSet == 2) ? 1 : 0,
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
                                                setState(() {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder:
                                                          (cxt) =>
                                                              const TagSelect()));
                                                });
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
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (cxt) =>
                                                    const TagSelect()));
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
                            //Login options
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              left: 0,
                              right: 0,
                              bottom:
                                  (_currentButtonSet == 3) ? _height / 6 : 0,
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
                                              setState(() {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (cxt) =>
                                                    const TagSelect()));
                                              });
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
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder:
                                                      (cxt) =>
                                                  const TagSelect()));
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

class CarouselItemBuilder extends StatelessWidget {
  const CarouselItemBuilder(
      {Key? key,
      required double width,
      required double height,
      required String imageUrl,
      required String poster,
      required String title,
      bool gifView = false})
      : _width = width,
        _height = height,
        _imageUrl = imageUrl,
        _title = title,
        _poster = poster,
        _gifView = gifView,
        super(key: key);

  final double _width;
  final double _height;
  final String _imageUrl;
  final String _poster;
  final String _title;
  final bool _gifView;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      !_gifView
          ? Image.asset(
              _imageUrl,
              width: _width,
              height: _height,
              fit: BoxFit.fitHeight,
            )
          : GifView.asset(
              _imageUrl,
              width: _width,
              height: _height,
              fit: BoxFit.fitHeight,
              frameRate: 8,
            ),
      Container(
        width: _width,
        height: _height,
        color: Colors.black.withOpacity(0.49),
      ),
      Positioned(
        child: Text(
          _poster,
          style: GoogleFonts.nunito(
              color: Colors.white38, fontWeight: FontWeight.w700, fontSize: 12),
        ),
        bottom: 25,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Container()),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 40.0),
                  child: Text(
                    _title,
                    textScaleFactor: 2.2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'favoritPro',
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8.0),
                          Shadow(color: Colors.white, blurRadius: 1.0)
                        ]),
                  ),
                ),
                Container(),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      )
    ]);
  }
}
