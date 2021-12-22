import "dart:async";
import "dart:ui";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Widgets/Exceptions_UI/generic_exception.dart";
import "package:tumbler/Widgets/Home/home_sliver_app_bar.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";

/// HomeSection enum facilitates handling multiple sub-pages in home page.
enum HomeSection {
  /// Following Page
  following,

  /// Stuff for you Page
  stuffForYou,
}

/// Show Posts Page (Dashboard)
class HomePageZiyad extends StatefulWidget {
  /// Constructor
  const HomePageZiyad({final Key? key}) : super(key: key);

  @override
  _HomePageZiyadState createState() => _HomePageZiyadState();
}

class _HomePageZiyadState extends State<HomePageZiyad>
    with TickerProviderStateMixin {
  ///saying which section the user is surfing.
  Enum section = HomeSection.following;

  /// true when posts are loading.
  bool _isLoading = false;

  /// true when error occurred
  bool _error = false;

  /// Indicate that more posts are fetched
  bool _gettingPosts = false;

  /// list of current home posts.
  List<PostModel> posts = <PostModel>[];

  late AnimationController loadingSpinnerAnimationController;

  /// for Pagination
  int currentPage = 0;

  final ScrollController _controller = ScrollController();

  Future<void> fetchPosts() async {
    setState(() => _isLoading = true);
    setState(() => _error = false);
    posts.clear();
    currentPage = 0;
    final Map<String, dynamic> response =
        await Api().fetchHomePosts(currentPage + 1);

    if (response["meta"]["status"] == "200") {
      if (response["response"] != <dynamic>{}) {
        currentPage++;
        posts.addAll(PostModel.fromJSON(response["response"]["posts"]));
      }
    } else {
      await showToast(response["meta"]["msg"]);
      setState(() => _error = true);
    }
    setState(() => _isLoading = false);
  }

  Future<void> getMorePosts() async {
    if (_gettingPosts) {
      return;
    }
    _gettingPosts = true;
    final Map<String, dynamic> response =
        await Api().fetchHomePosts(currentPage + 1);

    if (response["meta"]["status"] == "200") {
      if (response["response"] != <dynamic>{}) {
        currentPage++;
        setState(
          () => posts.addAll(PostModel.fromJSON(response["response"]["posts"])),
        );
      }
    } else
      await showToast(response["meta"]["msg"]);
    _gettingPosts = false;
  }

  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
    super.dispose();
  }

  /// Used to switch from __Following__ section
  /// to __Stuff for you__ section and vice versa.
  void changeSection() {
    setState(() {
      if (section == HomeSection.following) {
        section = HomeSection.stuffForYou;
      } else {
        section = HomeSection.following;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 50) {
        getMorePosts();
      }
    });

    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
    fetchPosts();
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
        body: Center(
          child: Container(
            color: Colors.white,
            width: (defaultTargetPlatform == TargetPlatform.windows ||
                    defaultTargetPlatform == TargetPlatform.linux ||
                    defaultTargetPlatform == TargetPlatform.macOS)
                ? MediaQuery.of(context).size.width * (2 / 3)
                : double.infinity,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              controller: ScrollController(),
              headerSliverBuilder:
                  (final BuildContext context, final bool innerBoxIsScrolled) =>
                      <Widget>[
                HomePageAppBar(
                  section: section,
                  changeSection: changeSection,
                )
              ],
              body: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: loadingSpinnerAnimationController.drive(
                          ColorTween(
                            begin: Colors.blueAccent,
                            end: Colors.red,
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchPosts,
                      child: _error
                          ? ListView(
                              children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 150),
                                  child: ErrorImage(
                                    msg: "Unexpected error,"
                                        " please try again later",
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              controller: _controller,
                              itemCount: posts.length,
                              itemBuilder: (
                                final BuildContext ctx,
                                final int index,
                              ) {
                                return PostOutView(
                                  post: posts[index],
                                );
                              },
                            ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
