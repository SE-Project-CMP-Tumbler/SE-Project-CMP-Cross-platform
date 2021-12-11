// ignore_for_file: lines_longer_than_80_chars

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";

/// to search for tumblers
class SearchPage extends StatefulWidget {
  /// constructor
  const SearchPage({final Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> _tabs = <String>["Posts", "Likes", "Following"];
  bool isExpanded = true;

  @override
  Widget build(final BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;

    void _onUpdateScroll(final ScrollMetrics metrics) {
      setState(() {
        if (metrics.extentBefore >= 100 && metrics.axis == Axis.vertical) {
          isExpanded = false;
        } else if (metrics.extentBefore < 100 &&
            metrics.axis == Axis.vertical) {
          isExpanded = true;
        }
      });
    }

    final List<String> backGrounds = <String>[
      "search_1.jpg",
      "search_2.jpg",
      "search_3.jpg",
      "search_4.jpg"
    ];
    return Scaffold(
      backgroundColor: navy,
      body: NotificationListener<ScrollNotification>(
        onNotification: (final ScrollNotification scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            _onUpdateScroll(scrollNotification.metrics);
          }
          return false;
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              pinned: true,
              expandedHeight: _height * 0.26,
              flexibleSpace: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      width: _width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/${backGrounds[2]}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                            left: 16,
                            right: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: AnimatedContainer(
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 300),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              width: isExpanded ? _width * 0.7 : _width,
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      CupertinoIcons.search,
                                      color: Colors.grey.shade700,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "Search Tumbler",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                //tags you follow
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              "Tags you follow",
                              textScaleFactor: 1.4,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Manage",
                                style: TextStyle(
                                  color: Colors.grey.withOpacity(0.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/${backGrounds[1]}",
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text(
                                        "#tagOne",
                                        textScaleFactor: 1.2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/${backGrounds[1]}",
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text(
                                        "#tagOne",
                                        textScaleFactor: 1.2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/${backGrounds[1]}",
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text(
                                        "#tagOne",
                                        textScaleFactor: 1.2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/${backGrounds[1]}",
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text(
                                        "#tagOne",
                                        textScaleFactor: 1.2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //check out these tags
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          "Check out these tags",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                // TODO(DONIA): make it random
                                color: Colors.red,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                // TODO(DONIA): make it depends
                                //  on the random background color
                                border: Border.all(
                                  color: Colors.redAccent,
                                  width: 1.5,
                                ),
                              ),
                              width: (_width / 3) + 15,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 16,
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                    ),
                                    child: Text(
                                      "#cats",
                                      textScaleFactor: 1.1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            child: Image.asset(
                                              "assets/images/${backGrounds[2]}",
                                              height: 65,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 6,
                                            top: 6,
                                            bottom: 6,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            child: Image.asset(
                                              "assets/images/${backGrounds[3]}",
                                              height: 65,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        right: 6,
                                        bottom: 4,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              //compute Luminance, if >0.4
                                              // then make it black,
                                              // else make it white
                                              MaterialStateProperty.all<Color>(
                                            Colors.white,
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.red,
                                          ),
                                          fixedSize: MaterialStateProperty.all(
                                            Size(_width, 45),
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(1),
                                        ),
                                        child: const Text(
                                          "Follow",
                                          textScaleFactor: 1.2,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //check out these blogs
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          "Check out these blogs",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                // TODO(DONIA): make it random
                                color: Color(0xFF867000),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              width: (_width / 3) + 30,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 90,
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: Image.asset(
                                            "assets/images/${backGrounds[1]}",
                                            width: _width,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const Positioned(
                                          top: 25,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: AssetImage(
                                                "assets/images/cat.png",
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      "Donia Esawi",
                                      textScaleFactor: 1.1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        right: 6,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              //compute Luminance, if >0.4
                                              // then make it black,
                                              // else make it white
                                              MaterialStateProperty.all<Color>(
                                            Colors.white,
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color(0xFF867000),
                                          ),
                                          fixedSize: MaterialStateProperty.all(
                                            Size(_width, 35),
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(1),
                                        ),
                                        child: const Text(
                                          "Follow",
                                          textScaleFactor: 1.2,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //try these posts
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          "Try these posts",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/women.png",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/cat.png",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/profile_pic.png",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/intro_1.gif",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/intro_2.gif",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/intro_3.jpg",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/intro_4.jpg",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/intro_5.gif",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/search_1.jpg",
                                    height: (_width / 3) - 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //things we care about
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          "Things we care about",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/${backGrounds[1]}",
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text(
                                        "#tagOne",
                                        textScaleFactor: 1.2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/${backGrounds[1]}",
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text(
                                        "#tagOne",
                                        textScaleFactor: 1.2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/${backGrounds[1]}",
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text(
                                        "#tagOne",
                                        textScaleFactor: 1.2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/${backGrounds[1]}",
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    width: _width / 3,
                                    height: (_width / 3) - 40,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text(
                                        "#tagOne",
                                        textScaleFactor: 1.2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //trending now
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Trending now",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Image.asset(
                                          "assets/images/1.png",
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            const Text(
                                              "trending one",
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "#tag1",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "#tag2",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        "Follow",
                                        textScaleFactor: 1.1,
                                        style: TextStyle(
                                          color: floatingButtonColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 53,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                      child: Image.asset(
                                        "assets/images/intro_1.gif",
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                      child: Image.asset(
                                        "assets/images/intro_2.gif",
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                      child: Image.asset(
                                        "assets/images/intro_3.jpg",
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                      child: Image.asset(
                                        "assets/images/intro_1.gif",
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
