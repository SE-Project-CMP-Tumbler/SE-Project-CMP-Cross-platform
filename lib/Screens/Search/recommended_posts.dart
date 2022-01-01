import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/random_posts.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Widgets/Exceptions_UI/error_dialog.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";

/// List of Random Posts
List<PostModel> randomPosts = <PostModel>[];

/// to show suggested posts (random) from the explore page
class RecommendedPosts extends StatefulWidget {
  /// constructor
  const RecommendedPosts({final Key? key}) : super(key: key);

  @override
  _RecommendedPostsState createState() => _RecommendedPostsState();
}

class _RecommendedPostsState extends State<RecommendedPosts>
    with TickerProviderStateMixin {
  /// true when posts are loading.
  bool _isLoading = true;

  /// true when posts are loading more pages
  bool _isLoadingMore = false;

  /// true when error occurred
  bool _error = false;

  /// true when it's first time to load
  bool _firstTime = true;

  /// to indicate if we reached the max page count or not
  bool reachedMax = false;

  /// the current page of the followed tags
  int currentPage = 1;
  AnimationController? loadingSpinnerAnimationController;

  /// single child scroll controller, to indicate if
  /// i reached the end of the screen or not
  final ScrollController _scrollController = ScrollController();

  // ignore: always_specify_types
  late Animation _colorTween;
  late AnimationController controller;

  /// Responsible for reloading all explore screen results
  Future<void> refreshRandomPostsPage(
    final BuildContext context,
  ) async {
    /// get random posts "try these posts"
    final List<PostModel> list =
        await getRandomPosts().catchError((final Object? error) {
      if (mounted)
        setState(() {
          _error = true;
          _isLoading = false;
        });

      showErrorDialog(context, "error on random posts\n${error.toString()}");
    });

    randomPosts.clear();
    randomPosts = list;

    if (_firstTime) {
      _firstTime = false;
    }
    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  // ignore: avoid_void_async
  void getMoreRandomPosts() async {
    if (reachedMax) {
      return;
    }
    setState(() {
      _isLoadingMore = true;
    });

    /// get random posts "try these posts"
    await getRandomPosts(page: currentPage).then((final List<PostModel> value) {
      setState(() {
        if (value.isNotEmpty) {
          if (randomPosts.isEmpty)
            randomPosts = value;
          else
            randomPosts.addAll(value);
        } else {
          reachedMax = true;
        }
        _isLoadingMore = false;
      });
    }).catchError((final Object? error) {
      setState(() {
        _error = true;
        _isLoadingMore = false;
      });
      showToast("error on random posts :: ${error.toString()}");
    });
  }

  @override
  void initState() {
    super.initState();

    /// Animation controller for the color varying loading spinner
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _colorTween = controller.drive(
      ColorTween(
        begin: Colors.deepPurpleAccent,
        end: floatingButtonColor,
      ),
    );
    _scrollController.addListener(() {
      if (!reachedMax) {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent &&
            !_isLoading &&
            !_isLoadingMore) {
          currentPage++;
          getMoreRandomPosts();
        }
      }
    });
    refreshRandomPostsPage(context);
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.white,
            size: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: navy,
        title: const Text(
          "Recommended for you",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading && _firstTime
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? Padding(
                  padding: EdgeInsets.only(top: _height / 6),
                  child: Column(
                    children: <Widget>[
                      Image.asset("assets/images/error.png"),
                      const Text(
                        "Something bad happened T_T\n try again later",
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                )
              : Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    RefreshIndicator(
                      onRefresh: () async {
                        await refreshRandomPostsPage(context);
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: randomPosts.isNotEmpty
                            ? Column(
                                children: randomPosts
                                    .map(
                                      (final PostModel post) => Container(
                                        color: Colors.white,
                                        child: PostOutView(
                                          key: Key(post.postId.toString()),
                                          post: post,
                                          index: randomPosts.indexOf(post),
                                          page: 5,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: _height / 6),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset("assets/images/404.png"),
                                    const Text(
                                      "OOPS, there's nothing here",
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                    if (_isLoadingMore)
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: _height,
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            valueColor: _colorTween as Animation<Color?>,
                          ),
                        ),
                      )
                    else
                      Container(),
                  ],
                ),
    );
  }
}
