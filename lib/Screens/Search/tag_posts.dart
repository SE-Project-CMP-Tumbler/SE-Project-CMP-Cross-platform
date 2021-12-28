import "dart:math";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:sliver_header_delegate/sliver_header_delegate.dart";
import "package:tumbler/Constants/urls.dart";
import "package:tumbler/Methods/get_tags.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";
/// for showing the posts (recent, tops) of a specific tag
class TagPosts extends StatefulWidget {
  /// constructor, takes tag description and image and a random color only
  const TagPosts({
    required final this.bgColor,
    required final this.tag,
    final Key? key,
  }) : super(key: key);
  /// color theme of the page (random color)
  final Color bgColor;
  /// a tag object that carries information:
  /// tag background image, tag description, is followed or not
  final Tag tag;
  @override
  _TagPostsState createState() => _TagPostsState();
}

class _TagPostsState extends State<TagPosts>  with TickerProviderStateMixin{
  late AnimationController loadingSpinnerAnimationController;
  ScrollController? _scrollController;
  TabController? tabController;
  /// to indicate whether the posts is loading or not
  bool _isLoading=true;
  List<PostModel> recentPosts= <PostModel>[];
  List<PostModel> topPosts= <PostModel>[];
  int _currentTab=0;
  int _postsCount=0;
  Future<void> getRecentTagPosts() async{
    setState(() {
      _isLoading=true;
    });
    /// get recent posts of the tag
    final List<PostModel> tagPosts= await getTagPosts(widget.tag.tagDescription!,);
    setState((){
      recentPosts =tagPosts;
    });

    setState(() {
      _isLoading=false;
    });
  }
  Future<void> getTopTagPosts() async{
    setState(() {
      _isLoading=true;
    });
    /// get top posts of the tag
    final List<PostModel> tagTopPosts= await getTagPosts
      (widget.tag.tagDescription!,recent: false,);
    setState(() {
      topPosts= tagTopPosts;
    });

    setState(() {
      _isLoading=false;
    });
  }

  // ignore: avoid_void_async
  void fetchAllPosts()async{
    setState(() {
      _isLoading=true;
    });
    /// get recent posts of the tag
     final List<PostModel> tagPosts= await getTagPosts(widget.tag.tagDescription!,);
    setState((){
      recentPosts =tagPosts;
    });
    /// get top posts of the tag
    final List<PostModel> tagTopPosts= await getTagPosts
      (widget.tag.tagDescription!,recent: false,);
    setState(() {
      topPosts= tagTopPosts;
    });
    setState(() {
      _isLoading=false;
    });

  }
  @override
  void initState() {
    super.initState();
    /// Animation controller for the color varying loading spinner
    tabController = TabController(length: 2, vsync: this);
    _scrollController= ScrollController();
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
    fetchAllPosts();
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
    final List<String> _tabs= <String> ["Recent", "Top"];
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body:NestedScrollView(
          floatHeaderSlivers: true,
          controller: _scrollController,
          headerSliverBuilder: (final BuildContext context, final bool value) {
            return <Widget>[
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
                    expandedHeight: 225,
                    background: MutableBackground(

                      animationDuration:  Duration.zero,
                      expandedWidget: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.network(
                            widget.tag.tagImgUrl??tumblerImgUrl,
                            width: _width,
                            height: 280,
                            fit: BoxFit.cover,
                          ),
                          Container(color: Colors.black26,width: _width,),
                          Positioned(
                              bottom: 20,
                              left: 32,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${widget.tag.postsCount} posts",
                                    style: TextStyle(color:
                                  widget.bgColor.computeLuminance()>0.5?
                                  Colors.black:Colors.white,),
                                    textScaleFactor: 1.4,),
                                  Row(
                                    children: <Widget>[
                                      ElevatedButton(onPressed: (){},
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(widget.bgColor),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all
                                            (Radius.circular(25),),),
                                        ),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric
                                              (horizontal: 32),),
                                      ),
                                          child: Text(widget.tag.isFollowed!?
                                          "UnFollow":"Follow",
                                            style: TextStyle(
                                              color:  widget.bgColor
                                                  .computeLuminance()>0.5?
                                              Colors.black:Colors.white,
                                            ),
                                            textScaleFactor: 1.2,),
                                      ),
                                      const SizedBox(width: 16,),
                                      ElevatedButton(onPressed: (){},
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all(widget.bgColor),
                                          shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all
                                                (Radius.circular(25),),),
                                          ),
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric
                                              (horizontal: 24),),
                                        ),
                                          child: Text("New Post",
                                            textScaleFactor: 1.2,
                                            style: TextStyle(
                                              color:  widget.bgColor
                                                  .computeLuminance()>0.5?
                                              Colors.black:Colors.white,
                                            ),
                                          ),),
                                    ],
                                  ),
                                ],
                              ),)
                        ],
                      ),
                      collapsedWidget:Stack(
                        alignment: Alignment.center,

                        children: <Widget>[
                          Image.network(
                            widget.tag.tagImgUrl??tumblerImgUrl,
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
                    collapsedElevation: 0,
                    children: <Widget>[
                      FlexibleTextItem(
                        text: "#${widget.tag.tagDescription}",
                        expandedAlignment: Alignment.bottomLeft,
                        collapsedAlignment: Alignment.bottomLeft,
                        collapsedPadding:const EdgeInsets.only(top: 16,
                          bottom: 16,
                            left: 65,),
                        expandedPadding:const EdgeInsets.only(top: 16,
                          bottom: 100,
                            left: 32,),
                        collapsedStyle: TextStyle(fontSize: 16,
                          color:  widget.bgColor
                              .computeLuminance()>0.5?
                          Colors.black:Colors.white,
                          fontWeight: FontWeight.w500,),
                        expandedStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color:  widget.bgColor
                              .computeLuminance()>0.5?
                          Colors.black:Colors.white,
                          fontSize: 34,),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  child: Container(
                    color:  widget.bgColor,
                    child: TabBar(
                      controller: tabController,
                      indicatorColor:  widget.bgColor
                          .computeLuminance()>0.5?
                      Colors.black:Colors.white,
                      labelColor:   widget.bgColor
                          .computeLuminance()>0.5?
                      Colors.black:Colors.white,
                      onTap: (final int index) async {
                        setState(() {
                          _currentTab= index;
                        });
                      },
                      // These are the widgets to put in each tab in the tab bar
                      tabs: _tabs
                          .map(
                            (final String name) => Tab(text: name),
                      )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: ()async{
              if(DefaultTabController.of(context)!.index==0) // Recent
                await getRecentTagPosts();
              else
                await getTopTagPosts();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: TabBarView(
                controller: tabController,
                children: _tabs.map((final String e) => Text(e)).toList(),
              ),
            ),
          ),
        ),

      ),
    );

  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required final this.minHeight,
    required final this.maxHeight,
    required final this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      final BuildContext context,
      final double shrinkOffset,
      final bool overlapsContent,
      ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(final _SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
