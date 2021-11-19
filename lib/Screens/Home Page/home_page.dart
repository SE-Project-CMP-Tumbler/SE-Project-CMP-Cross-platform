import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/general_widgets/nav_bar.dart';
import '../../Widgets/Post/post_overview.dart';
import "../../Providers/posts.dart";
import '../../Models/post.dart';
import '../../Widgets/home_page_appbar.dart';

enum HomeSection {
  following,
  stuffForYou,
}

Future<void> fetchingPostsErrorHandler(BuildContext context,String mess) async {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Text("An error occurred"),
            content:  Text(mess),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'))
            ],
          ));
}

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
  int _navBarIndex = 0;
  Enum section = HomeSection.following;
  bool _isLoading = false;
  bool _isInit = false;

  List<Post> posts = [];

  late AnimationController animationController;
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  Future<void> refreshHome(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Posts>(context, listen: false).fetchAndSetPosts().then((_) {
      posts = Provider.of<Posts>(context, listen: false).homePosts;
      _isLoading = false;
    }).catchError((error) {
      fetchingPostsErrorHandler(context,error.toString());
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
        fetchingPostsErrorHandler(context,error.toString());
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  void changeSection() {
    setState(() {
      if (section == HomeSection.following) {
        section = HomeSection.stuffForYou;
      } else {
        section = HomeSection.following;
      }
      print('we r changign section now');
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
                        valueColor: animationController.drive(ColorTween(
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
        bottomNavigationBar: NavBar(_navBarIndex),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.mode_edit_outline_outlined,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
