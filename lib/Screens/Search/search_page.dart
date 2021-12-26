import "dart:math";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:random_color/random_color.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/random_bg.dart";
import "package:tumbler/Methods/get_all_blogs.dart";
import "package:tumbler/Methods/get_tags.dart";
import "package:tumbler/Methods/random_posts.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Providers/tags.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";
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

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin{
  bool isExpanded = true;
  /// true when posts are loading.
  bool _isLoading = false;

  /// true when error occurred
  bool _error = false;

  /// true when it's first time to load
  bool _firstTime =true;

  /// random index of background
  int _bgIndex= 1;
  AnimationController? loadingSpinnerAnimationController;

  final List<String> backGrounds = randomBg;
  List<Tag> tags = <Tag>[];
  List<Blog> checkOutBlogs=<Blog>[];
  List<String> randomPostsImgUrl=<String>[];
  List<Post> randomPosts=<Post>[];
  List<Tag> tagsToFollow=<Tag>[];
  List<Tag> trendingTags=<Tag>[];
  Map<Blog,Color> blogsBgColors=<Blog,Color>{};
  Map<Tag,Color> tagsBgColors=<Tag,Color>{};
  Map<Tag, List<Post>> tagsPosts=<Tag, List<Post>>{};
  @override
  void initState() {

    super.initState();
    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController!.repeat();
    getFollowedTags();
  }

  @override
  void dispose() {
    loadingSpinnerAnimationController!.dispose();
    super.dispose();
  }

  Future<void> getFollowedTags() async {
    if (Provider.of<Tags>(context, listen: false).followedTags.isEmpty) {
        await refreshSearchPage(
          context,
        );
    }
  }
  /// Responsible refreshing search page
  Future<void> refreshSearchPage(final BuildContext context,)
  async {
    _error = false;
    setState((){
      _isLoading = true;

    });
    /// get random blogs
    await getRandomBlogs().then((final List<Blog> value) {
      setState((){checkOutBlogs= value;});
      for(int i =0; i<value.length; i++)
        {
          blogsBgColors[value[i]]= RandomColor().randomColor();
        }
    }).catchError((final Object? error) {
      setState(() {
        _error = true;
        _isLoading = false;
      });
      showErrorDialog(context, "error on check out blogs${error.toString()}");
    });
    /// get random posts "try these posts"
    await getRandomPosts().then((final List<Post> value) {
      setState((){randomPosts= value;});
    }).catchError((final Object? error) {
      setState(() {
        _error = true;
        _isLoading = false;
      });
      showErrorDialog(context,  "error on check out posts${error.toString()}");
    });
    /// get random suggesting tags
    await getTagsToFollow().then((final List<Tag> value) {
      setState((){tagsToFollow= value;});
      for(int i =0; i<value.length; i++)
      {
        setState(() {
          tagsBgColors[value[i]]= RandomColor().randomColor();
        });
      }
    }).catchError((final Object? error) {
      setState(() {
        _error = true;
        _isLoading = false;
      });
      showErrorDialog(context, "error on random suggesting tags"
          "${error.toString()}",);

    });
    /// get trending tags
    await getTrendingTagsToFollow().then((final List<Tag> value) async{
      setState((){
      if(value.length<=9)
        trendingTags= value;
      else {
        trendingTags=<Tag>[];
        for (int i = 0; i < 9; i++) {
          trendingTags.add(value[i]);
        }
      }
      });
      /// for each trending tag, get their posts
      for (final Tag tTag in trendingTags)
      {
        await getTagPosts(tTag.tagDescription!).then((final List<Post> value) {
          setState((){tagsPosts[tTag]= value;});
        }).catchError((final Object? error) {
          setState(() {
            _error = true;
            _isLoading = false;
          });
          showErrorDialog(context, "from get tag posts ${error.toString()}");
        });
      }
    }).catchError((final Object? error) {
      setState(() {
        _error = true;
        _isLoading = false;
      });
      showErrorDialog(context,"from get trending tags ${error.toString()}");
    });

    /// get followed tags
    await Provider.of<Tags>(context, listen: false)
        .fetchAndSetFollowedTags()
        .then((final _) {
      setState(() {
        tags = Provider.of<Tags>(context,listen: false).followedTags;
        _isLoading = false;
        if(_firstTime)
          _firstTime= false;
      });
    }).catchError((final Object? error) {
      setState(() {
        _isLoading = false;
        _error = true;
      });
      showErrorDialog(context, "error from getting followed tags${error.toString()}");
    });


  }
  @override
  Widget build(final BuildContext context) {
    /// listening on changes
    tags = Provider.of<Tags>(context).followedTags;
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
            await refreshSearchPage(
              context,
            );

            setState(() {
            _bgIndex= Random().nextInt(10000)%backGrounds.length;
            });
          },
          edgeOffset:_height * 0.3,
          child: CustomScrollView(
            slivers: <Widget>[
              SearchHeader(height: _height, width: _width,
                  backGround: backGrounds[_bgIndex],
                  isExpanded: isExpanded,
                  recommendedTags: trendingTags,),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  if (_isLoading&& _firstTime) Center(
                    heightFactor: 15,
                    child: CircularProgressIndicator(
                      valueColor:
                      loadingSpinnerAnimationController!.drive(
                        ColorTween(
                          begin: Colors.blueAccent,
                          end: Colors.red,
                        ),
                      ),
                    ),
                  ) else SingleChildScrollView(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      // tags you follow
                        if (tags.isNotEmpty)
                          TagsYouFollow(tags:tags, width: _width)
                        else Container(),
                      // check out these tags section
                        if (tagsToFollow.isNotEmpty) CheckOutTags(
                        width: _width,
                        tagsToFollow:tagsToFollow,
                        tagsBg: tagsBgColors,) else Container(),
                      // check out these blogs
                        if (checkOutBlogs.isNotEmpty) CheckOutBlogs(
                        width: _width,
                        blogs: checkOutBlogs,
                        blogsBg: blogsBgColors,) else Container(),
                      // try these posts
                        if (randomPosts.isNotEmpty)
                          TryThesePosts(randomPosts:randomPosts,)
                        else Container(),
                      // trending now
                        if (trendingTags.isNotEmpty)
                          Trending(trendingTags: trendingTags,
                              tagPosts: tagsPosts,)
                        else Container(),
                    ],),
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








