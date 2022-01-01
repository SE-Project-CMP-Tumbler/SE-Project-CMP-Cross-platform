// ignore_for_file: prefer_final_fields

import "dart:math";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/random_bg.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Providers/tags.dart";
import "package:tumbler/Widgets/Search/check_out_blogs.dart";
import "package:tumbler/Widgets/Search/check_out_tags.dart";
import "package:tumbler/Widgets/Search/search_header.dart";
import "package:tumbler/Widgets/Search/tags_you_follow.dart";
import "package:tumbler/Widgets/Search/trendings.dart";
import "package:tumbler/Widgets/Search/try_these_posts.dart";

/// to search for tumblers
class SearchPage extends StatefulWidget {
  /// constructor
  const SearchPage({final Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  bool isExpanded = true;

  /// true when posts are loading.
  bool _isLoading = false;

  /// true when error occurred
  // ignore: unused_field
  bool _error = false;

  /// true when it's first time to load
  bool _firstTime = true;

  /// random index of background
  int _bgIndex = 1;
  AnimationController? loadingSpinnerAnimationController;

  final List<String> backGrounds = randomBg;
  List<Tag> tags = <Tag>[];
  List<Blog> checkOutBlogs = <Blog>[];
  List<String> randomPostsImgUrl = <String>[];
  List<PostModel> randomPosts = <PostModel>[];
  List<Tag> tagsToFollow = <Tag>[];
  List<Tag> trendingTags = <Tag>[];
  Map<Blog, Color> blogsBgColors = <Blog, Color>{};
  Map<Tag, Color> tagsBgColors = <Tag, Color>{};
  Map<Tag, List<PostModel>> tagsPosts = <Tag, List<PostModel>>{};

  @override
  void initState() {
    super.initState();

    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController!.repeat();
    WidgetsBinding.instance!.addPostFrameCallback(
      (
        final _,
      ) =>
          getAllSections(),
    );
  }

  // ignore: avoid_void_async
  void getAllSections() async {
    setState(() {
      _isLoading = false;
    });
    if (mounted &&
        Provider.of<Tags>(context, listen: false).isLoaded == false) {
      await Provider.of<Tags>(context, listen: false).refreshSearchPage(
        context,
      );
      setState(() {
        _isLoading = false;
        _firstTime = false;
      });
    }
  }

  @override
  void dispose() {
    loadingSpinnerAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    /// listening on changes
    tags = Provider.of<Tags>(context).followedTags;
    checkOutBlogs = Provider.of<Tags>(context).checkOutBlogs;
    randomPosts = Provider.of<Tags>(context).randomPosts;
    tagsToFollow = Provider.of<Tags>(context).tagsToFollow;
    trendingTags = Provider.of<Tags>(context).trendingTags;
    blogsBgColors = Provider.of<Tags>(context).blogsBgColors;
    tagsBgColors = Provider.of<Tags>(context).tagsBgColors;
    tagsPosts = Provider.of<Tags>(context).tagsPosts;
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

    return Scaffold(
      backgroundColor: navy,
      body: NotificationListener<ScrollNotification>(
        onNotification: (final ScrollNotification scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            _onUpdateScroll(scrollNotification.metrics);
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<Tags>(context, listen: false)
                .refreshSearchPage(context);
            setState(() {
              _bgIndex = Random().nextInt(10000) % backGrounds.length;
            });
          },
          edgeOffset: _height * 0.3,
          child: CustomScrollView(
            slivers: <Widget>[
              SearchHeader(
                height: _height,
                width: _width,
                backGround: backGrounds[_bgIndex],
                isExpanded: isExpanded,
                recommendedTags: trendingTags,
              ),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  if (_isLoading && _firstTime)
                    Center(
                      heightFactor: 15,
                      child: CircularProgressIndicator(
                        valueColor: loadingSpinnerAnimationController!.drive(
                          ColorTween(
                            begin: Colors.blueAccent,
                            end: Colors.red,
                          ),
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // tags you follow

                          TagsYouFollow(tags: tags, width: _width),
                          // check out these tags section
                          CheckOutTags(
                            width: _width,
                            tagsToFollow: tagsToFollow,
                            tagsBg: tagsBgColors,
                          ),
                          // check out these blogs
                          CheckOutBlogs(
                            blogs: checkOutBlogs,
                            blogsBg: blogsBgColors,
                          ),
                          // try these posts

                          TryThesePosts(
                            randomPosts: randomPosts,
                          ),
                          // trending now

                          Trending(
                            trendingTags: trendingTags,
                            tagPosts: tagsPosts,
                          ),
                        ],
                      ),
                    ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
