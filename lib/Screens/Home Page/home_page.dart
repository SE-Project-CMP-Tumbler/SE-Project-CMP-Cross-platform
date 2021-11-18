import 'dart:ui';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/general_widgets/nav_bar.dart';
import '../../Widgets/Post/post_overview.dart';
import 'package:provider/provider.dart';
import "../../Providers/posts.dart";
import '../../Models/post.dart';

enum HomeSection {
  following,
  stuffForYou,
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
    // TODO: implement dispose
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

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Posts>(context).fetchAndSetPosts().then((_) {
        posts = Provider.of<Posts>(context, listen: false).homePosts;
        _isLoading = false;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          controller: ScrollController(
            initialScrollOffset: 0.0,
          ),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Color.fromRGBO(0, 25, 53, 1),
              leading: Image.asset(
                'assets/images/tumblr-24.png',
              ),
              titleSpacing: 0,
              title: Row(
                children: [
                  TextButton(
                      onPressed: changeSection,
                      child: Text("Following",
                          style: TextStyle(
                              color: (section == HomeSection.following)
                                  ? Colors.blue
                                  : Colors.grey,
                              fontSize: 17))),
                  TextButton(
                      onPressed: changeSection,
                      child: Text("Stuff for you",
                          style: TextStyle(
                              color: (section == HomeSection.stuffForYou)
                                  ? Colors.blue
                                  : Colors.grey,
                              fontSize: 17)))
                ],
              ),
            ),
          ],
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: animationController.drive(
                        ColorTween(begin: Colors.blueAccent, end: Colors.red)),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    Future.delayed(Duration.zero).then((_) {});
                  },
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
