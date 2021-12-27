import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import "package:tumbler/Constants/colors.dart";
/// for showing the posts (recent, tops) of a specific tag
class TagPosts extends StatefulWidget {
  /// constructor, takes tag description and image and a random color only
  const TagPosts({Key? key}) : super(key: key);

  @override
  _TagPostsState createState() => _TagPostsState();
}

class _TagPostsState extends State<TagPosts>  with TickerProviderStateMixin{
  late AnimationController loadingSpinnerAnimationController;
  ScrollController? _scrollController;
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    /// Animation controller for the color varying loading spinner
    tabController = TabController(length: 2, vsync: this);
    _scrollController= ScrollController();
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
  }
  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
    tabController!.dispose();
    _scrollController!.dispose();
    super.dispose();
  }
  @override
  Widget build(final BuildContext context) {
    final double _width= MediaQuery.of(context).size.width;
    final double _height= MediaQuery.of(context).size.height;
    final List<String> _tabs= <String> ["Recent", "Top"];
    return Scaffold(
      body:NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(

                pinned: true,
                delegate: FlexibleHeaderDelegate(
                  leading:IconButton(
                    icon: const Icon(CupertinoIcons.arrow_left,size: 20,),
                    onPressed: () {},
                  ),
                  statusBarHeight: MediaQuery.of(context).padding.top,
                  expandedHeight: 265,
                  background: MutableBackground(
                    animationDuration:  Duration.zero,
                    expandedWidget: Stack(
                      alignment: Alignment.center,

                      children: <Widget>[
                        Image.asset(
                          "assets/images/search_2.jpg",
                          width: _width,
                          fit: BoxFit.cover,
                        ),
                        Container(color: Colors.black26,width: _width,),
                        Positioned(
                            bottom: 55,
                            left: 32,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("120 posts",style: TextStyle(color: Colors.white,),textScaleFactor: 1.4,),
                                Row(
                                  children: [
                                    ElevatedButton(onPressed: (){}, child: Text("Follow")),
                                    SizedBox(width: 32,),
                                    ElevatedButton(onPressed: (){}, child: Text("New Post")),
                                  ],
                                ),
                              ],
                            ))
                      ],
                    ),
                    collapsedWidget:Stack(
                      alignment: Alignment.center,

                      children: [
                        Image.asset(
                          'assets/images/search_2.jpg',
                          width: _width,
                          fit: BoxFit.cover,
                        ),
                        Container(color: Colors.black26,width: _width,),
                      ],
                    ),
                  ),
                  actions:<Widget> [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                  ],
                  children: <Widget>[
                    const FlexibleTextItem(
                      text: "#Mountains",
                      expandedAlignment: Alignment.bottomLeft,
                      collapsedAlignment: Alignment.bottomLeft,
                      collapsedPadding: EdgeInsets.only(top: 16, bottom: 16, left: 65),
                      expandedPadding: EdgeInsets.only(top: 16, bottom: 130, left: 32),
                      collapsedStyle: TextStyle(fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,),
                      expandedStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 34,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 220),
                      child: Container(
                        color: Colors.white,

                        child: TabBar(

                          controller: tabController,
                          indicatorColor: floatingButtonColor,
                          labelColor: floatingButtonColor,
                          // These are the widgets to put in each tab in the tab bar
                          tabs: _tabs
                              .map(
                                (final String name) => Tab(text: name,),
                          )
                              .toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          margin: EdgeInsets.only(top: 50),
          child: TabBarView(
            controller: tabController,
            children: _tabs.map((e) => Text(e)).toList(),
          ),
        ),
      ),

    );

  }
}
