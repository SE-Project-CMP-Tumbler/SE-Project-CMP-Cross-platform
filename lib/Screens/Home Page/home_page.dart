import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/post.dart';
import "../../Providers/posts.dart";
import '../../Widgets/Post/post_overview.dart';
import '../../Widgets/home_page_appbar.dart';

enum HomeSection {
  following,
  stuffForYou,
}

///Shows informative message about an error occurred while fetching posts in home page.
///
///Takes [context] object and error message.
Future<void> showErrorDialog(BuildContext context, String mess) async {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Text("An error occurred"),
            content: Text(mess),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'))
            ],
          ));
}

///Shows modal bottom sheet when the user clicks on more vert icon button in a post.
void showEditPostBottomSheet(BuildContext ctx) {
  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: ctx,
    builder: (_) {
      return Container(
        height: 200,
        color: Colors.black38,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {},
                child: const Text(
                  "Report sensitive content",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {},
                child: const Text(
                  "Repost spam",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {},
                child: const Text(
                  "Report something else",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {},
                child: const Text(
                  "Copy link",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      );
    },
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
  List<Post> posts = [];

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
  Future<void> refreshHome(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Posts>(context, listen: false).fetchAndSetPosts().then((_) {
      posts = Provider.of<Posts>(context, listen: false).homePosts;
      _isLoading = false;
    }).catchError((error) {
      showErrorDialog(context, error.toString());
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Posts>(context).fetchAndSetPosts().then((_) {
        posts = Provider.of<Posts>(context, listen: false).homePosts;
        _isLoading = false;
      }).catchError((error) {
        showErrorDialog(context, error.toString());
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  /// Used to switch from __Following__ section to __Stuff for you__ section and vice versa.
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
  Widget build(BuildContext context) {
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
              controller: ScrollController(
                initialScrollOffset: 0.0,
              ),
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                                begin: Colors.blueAccent, end: Colors.red)),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => refreshHome(context),
                      child: Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  PostOutView(
                                      showEditPostBottomSheet:
                                          showEditPostBottomSheet,
                                      post: posts[index]),
                                  Container(
                                    height: 10,
                                    color: const Color.fromRGBO(0, 25, 53, 1),
                                  )
                                ],
                              );
                            },
                            itemCount: posts.length,
                          )),
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
