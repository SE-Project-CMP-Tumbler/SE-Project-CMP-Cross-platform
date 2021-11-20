import "dart:async";
import "dart:ui";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Models/post.dart";
import "package:tumbler/Providers/posts.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";
import "package:tumbler/Widgets/home_page_appbar.dart";

/// HomeSection enum facilitates handling multiple sub-pages in home page.
enum HomeSection {
  /// Following Page
  following,

  /// Stuff for you Page
  stuffForYou,
}

///Shows informative message about an error occurred
/// while fetching posts in home page.
///
///Takes [context] object and error message.
Future<void> showErrorDialog(
  final BuildContext context,
  final String mess,
) async {
  await showDialog(
    context: context,
    builder: (final BuildContext ctx) => AlertDialog(
      title: const Text("An error occurred"),
      content: Text(mess),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text("Okay"),
        )
      ],
    ),
  );
}

///Shows modal bottom sheet when
///the user clicks on more vert icon button in a post.
void showEditPostBottomSheet(final BuildContext ctx) {
  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: ctx,
    builder: (final _) {
      return Container(
        height: 200,
        color: Colors.black38,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Text(
                "Report sensitive content",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Repost spam",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Report something else",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Copy link",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Show Posts Page (Dashboard)
class HomePage extends StatefulWidget {
  /// Constructor
  const HomePage({final Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ///saying which section the user is surfing.
  Enum section = HomeSection.following;

  /// true when posts are loading.
  bool _isLoading = false;

  ///true after first successful posts fetching.
  bool _isInit = false;

  /// list of current home posts.
  List<Post> posts = <Post>[];

  late AnimationController loadingSpinnerAnimationController;

  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
  }

  /// Responsible refreshing home page and fetch new post to show.
  Future<void> refreshHome(final BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Posts>(context, listen: false)
        .fetchAndSetPosts()
        .then((final _) {
      setState(() {
        posts = Provider.of<Posts>(context, listen: false).homePosts;
        _isLoading = false;
      });
    }).catchError((final Object? error) {
      showErrorDialog(context, error.toString());
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    if (!_isInit) {
      setState(() => _isLoading = true);

      await Provider.of<Posts>(context).fetchAndSetPosts().then((final _) {
        setState(() {
          posts = Provider.of<Posts>(context, listen: false).homePosts;
          _isLoading = false;
        });
      }).catchError((final Object? error) {
        showErrorDialog(context, error.toString());
      });
    }
    _isInit = true;
    super.didChangeDependencies();
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
                      onRefresh: () => refreshHome(context),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemBuilder:
                                  (final BuildContext ctx, final int index) {
                                return Column(
                                  children: <Widget>[
                                    PostOutView(
                                      showEditPostBottomSheet:
                                          showEditPostBottomSheet,
                                      post: posts[index],
                                    ),
                                    Container(
                                      height: 10,
                                      color: const Color.fromRGBO(0, 25, 53, 1),
                                    )
                                  ],
                                );
                              },
                              itemCount: posts.length,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
