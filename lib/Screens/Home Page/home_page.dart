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
                child: const Text("Report sensitive content")),
            TextButton(onPressed: () {}, child: const Text("Repost spam")),
            TextButton(
                onPressed: () {}, child: const Text("Report something else")),
            TextButton(onPressed: () {}, child: const Text("Copy link")),
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

class _HomePageState extends State<HomePage> {
  int _navBarIndex = 0;
  Enum section = HomeSection.following;
  bool _isLoading = false;
  bool _isInit = false;

  List<Post> posts = [];

// Data injection (for testing purposes)
  // @override
  // void initState() {
  //   http.post(
  //       Uri.parse(
  //           "https://mock-back-default-rtdb.firebaseio.com/homePost.json"),
  //       body: json.encode({
  //         'postUserName': 'Iron Man 5',
  //         'postBody': "https://pbs.twimg.com/media/EiC-uBVX0AEfEIY.jpg",
  //         'isFavorite': true,
  //         'postAvatar':
  //             "https://www.techinn.com/f/13806/138068257/hasbro-marvel-legends-iron-man-electronic-helmet.jpg",
  //         'notesNum': 2062,
  //       }));
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Posts>(context).fetchAndSetPosts().then((_) {
        posts = Provider.of<Posts>(context,listen: false).homePosts;/////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!WHY FALSE IS NEEDED TO WORK????
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
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.black87,
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
        body: RefreshIndicator(
          onRefresh: () async {
            Future.delayed(Duration.zero).then((_) {});
          },
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return PostOutView(
                      showEditPostBottomSheet: showEditPostBottomSheet,
                      post: posts[index]);
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
    );
  }
}
