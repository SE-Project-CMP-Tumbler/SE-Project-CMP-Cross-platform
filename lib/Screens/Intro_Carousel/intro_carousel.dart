import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Screens/Intro_Carousel/page1.dart";
import "package:tumbler/Screens/Intro_Carousel/page2.dart";
import "package:tumbler/Screens/Intro_Carousel/page3.dart";
import "package:tumbler/Screens/Intro_Carousel/page4.dart";
import "package:tumbler/Screens/Intro_Carousel/page5.dart";
import "package:tumbler/Screens/Intro_Carousel/page6.dart";
import "package:tumbler/Screens/Intro_Carousel/page7.dart";
import "package:tumbler/Screens/main_screen.dart";

/// Intro Carousel Pages
class IntroCarousel extends StatefulWidget {
  @override
  _IntroCarouselState createState() => _IntroCarouselState();
}

class _IntroCarouselState extends State<IntroCarousel> {
  int _currentPage = 0;
  CarouselController? _carouselController;
  Color _selectedPageIndicatorColor = Colors.yellow;
  bool outerAnimationEnded = false;
  bool lastAnimationDone = false;
  bool enableGetStarted = false;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: _selectedPageIndicatorColor,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CarouselSlider(
              items: <Widget>[
                Page1(),
                AnimatedOpacity(
                  opacity: _currentPage == 1 ? 1 : 0,
                  duration: const Duration(milliseconds: 800),
                  child: Page2(),
                ),
                Page3(),
                Page4(),
                Page5(),
                Page6(),
                Page7(),
              ],
              carouselController: _carouselController,
              options: CarouselOptions(
                autoPlayAnimationDuration: const Duration(milliseconds: 400),
                autoPlayInterval: const Duration(milliseconds: 2000),
                onPageChanged: (final int page, final _) {
                  setState(() {
                    _currentPage = page;
                    if (_currentPage == 0 || _currentPage == 1) {
                      setState(
                        () => _selectedPageIndicatorColor = Colors.yellow,
                      );
                    } else if (_currentPage == 2) {
                      setState(
                        () => _selectedPageIndicatorColor =
                            Colors.deepPurpleAccent,
                      );
                    } else if (_currentPage == 3) {
                      setState(
                        () => _selectedPageIndicatorColor = Colors.pinkAccent,
                      );
                    } else if (_currentPage == 4) {
                      setState(
                        () => _selectedPageIndicatorColor =
                            const Color(0xFFFD8800),
                      );
                    } else if (_currentPage == 5) {
                      setState(
                        () => _selectedPageIndicatorColor =
                            const Color(0xFF00B7FD),
                      );
                    } else if (_currentPage == 6) {
                      setState(
                        () => _selectedPageIndicatorColor =
                            const Color(0xFF00CD35),
                      );
                    }
                  });
                },
                viewportFraction: 1,
                height: _height,
                autoPlay: _currentPage == 6 ? false : true,
                scrollPhysics: const NeverScrollableScrollPhysics(),
                enableInfiniteScroll: false,
                pauseAutoPlayOnTouch: false,
              ),
            ),
            Positioned(
              top: 20,
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOutCubic,
                      width: 14 + _currentPage * (25 + 6),
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            (_currentPage == 2) ? Colors.white : Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildPageIndicator(0),
                          const SizedBox(
                            width: 25,
                          ),
                          buildPageIndicator(1),
                          const SizedBox(
                            width: 25,
                          ),
                          buildPageIndicator(2),
                          const SizedBox(
                            width: 25,
                          ),
                          buildPageIndicator(3),
                          const SizedBox(
                            width: 25,
                          ),
                          buildPageIndicator(4),
                          const SizedBox(
                            width: 25,
                          ),
                          buildPageIndicator(5),
                          const SizedBox(
                            width: 25,
                          ),
                          buildPageIndicator(6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: _currentPage < 5 ? -500 : 10,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 800),
              onEnd: () {
                setState(() {
                  outerAnimationEnded = true;
                });
              },
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: FloatingActionButton(
                        onPressed: () {},
                        heroTag: "intro_carousel",
                        backgroundColor: navy,
                        elevation: 0,
                        child: Icon(
                          Icons.mode_edit_outline_outlined,
                          size: 29,
                          color: _selectedPageIndicatorColor,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (enableGetStarted) {
                              //push main here
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<MainScreen>(
                                  builder: (final BuildContext context) =>
                                      MainScreen(),
                                ),
                                // ignore: always_specify_types
                                (final Route route) => false,
                              );
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 70,
                                color: Colors.transparent,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 800),
                                  onEnd: () {
                                    setState(() {
                                      lastAnimationDone = true;
                                    });
                                  },
                                  width: _currentPage == 6 ? 70 : 0,
                                  height: _currentPage == 6 ? 70 : 0,
                                  decoration: BoxDecoration(
                                    color: _currentPage == 6
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                              Icon(Icons.home_filled, size: 35, color: navy),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              width: 70,
                              height: 70,
                              color: Colors.transparent,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                width: _currentPage == 5 && outerAnimationEnded
                                    ? 70
                                    : 0,
                                height: _currentPage == 5 && outerAnimationEnded
                                    ? 70
                                    : 0,
                                decoration: BoxDecoration(
                                  color:
                                      _currentPage == 5 && outerAnimationEnded
                                          ? Colors.white
                                          : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.search_outlined, size: 35, color: navy),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Icon(Icons.chat_bubble, size: 35, color: navy),
                      ),
                      Expanded(
                        child: Icon(
                          CupertinoIcons.person_solid,
                          size: 35,
                          color: navy,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            AnimatedPositioned(
              bottom: 100,
              left: _currentPage == 6 && lastAnimationDone ? 15 : -500,
              duration: const Duration(milliseconds: 600),
              onEnd: () {
                setState(() {
                  enableGetStarted = true;
                });
              },
              child: Column(
                children: const <Widget>[
                  Text(
                    "Get",
                    textScaleFactor: 1.5,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Started",
                    textScaleFactor: 1.5,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.arrow_downward_sharp,
                    color: Colors.white,
                    size: 25,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Stack buildPageIndicator(final int page) {
    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 1600),
          curve: Curves.easeInOutCubic,
          width: (_currentPage >= page) ? 6 : 10,
          height: (_currentPage >= page) ? 6 : 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black26,
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1600),
              curve: Curves.easeInOutCubic,
              width: (_currentPage >= page) ? 6 : 10.0,
              height: (_currentPage >= page) ? 6 : 10.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular((_currentPage >= page) ? 3 : 5),
                color: (_currentPage >= page)
                    ? _selectedPageIndicatorColor
                    : Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
