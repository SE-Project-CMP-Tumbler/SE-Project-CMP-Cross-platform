import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/random_posts.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Widgets/Exceptions_UI/error_dialog.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";

List<PostModel> recommendedPosts = <PostModel>[];

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
  bool _isLoading = false;

  /// true when error occurred
  bool _error = false;

  /// true when it's first time to load
  bool _firstTime = true;
  AnimationController? loadingSpinnerAnimationController;

  /// Responsible for reloading all explore screen results
  Future<void> refreshRandomPostsPage(final BuildContext context,)
  async {

      _isLoading = true;
      _isLoadingMore=false;
      reachedMax = false;
      _error = false;


    /// get random posts "try these posts"
    await getRandomPosts().then((final List<PostModel> value) {
        randomPosts.clear();
        randomPosts= value;
        if(_firstTime)
          _firstTime=false;
        _isLoading= false;}
    ).catchError((final Object? error) {

        _error = true;
        _isLoading = false;

      showErrorDialog(context,  "error on random posts\n${error.toString()}");
    });
  }
  // ignore: avoid_void_async
  void getMoreRandomPosts()async{
    if(reachedMax)
      {
        return;
      }
    setState((){
      _isLoadingMore = true;
    });

    /// get random posts "try these posts"
    await getRandomPosts(page: currentPage).then((final List<PostModel> value) {
      setState(() {
        if (value.isNotEmpty) {
          if(randomPosts.isEmpty)
            randomPosts = value;
          else
            randomPosts.addAll(value);
        }
        else
          {
            reachedMax=true;
          }
        _isLoadingMore = false;
      }
      );
    }).catchError((final Object? error) {
      setState(() {
        _error = true;
        _isLoading = false;
      });
      showErrorDialog(context, "error on random posts\n${error.toString()}");
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
          : SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () async {
                  await refreshRandomPostsPage(context);
                },
                child: recommendedPosts.isNotEmpty
                    ? ListView.builder(
                        itemBuilder:
                            (final BuildContext context, final int index) {
                          return Container(
                            color: Colors.white,
                            child: PostOutView(
                              key: Key(
                                  recommendedPosts[index].postId.toString()),
                              post: recommendedPosts[index],
                              index: index, page: 5, //dump
                            ),
                          );
                        },
                      )
                    : Container(),
              ),
            ),
    );
  }
}
