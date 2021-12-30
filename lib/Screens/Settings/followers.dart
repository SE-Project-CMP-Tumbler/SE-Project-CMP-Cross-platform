// ignore_for_file: public_member_api_docs

import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/followers_model.dart";
import "package:tumbler/Widgets/Exceptions_UI/empty_list_exception.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

class MyFollowers extends StatefulWidget {
  const MyFollowers({final Key? key}) : super(key: key);

  @override
  _MyFollowersState createState() => _MyFollowersState();
}

class _MyFollowersState extends State<MyFollowers>
    with TickerProviderStateMixin {
  late List<dynamic> followers = [];
  bool isLoading = false;

  late AnimationController loadingSpinnerAnimationController;

  Future<void> initFollowers() async {
    setState(() {
      isLoading = true;
    });
    final Map<String, dynamic> response = await Api().getFollowers();

    if (response["meta"]["status"] == "200") {
      final dynamic temp = response["response"]["followers"];

      followers = temp.map((final dynamic jsonData) {
        return Follower(
          blog_avatar: jsonData["blog_avatar"],
          blog_id: jsonData["blog_id"],
          blog_avatar_shape: jsonData["blog_avatar_shape"],
          blog_username: jsonData["blog_username"],
        );
      }).toList();
    }

    setState(() {
      isLoading = false;
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();

    initFollowers().then((final _) {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Followers",
        ),
      ),
      body: isLoading
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
          : followers.isEmpty
          ? const EmptyBoxImage(msg: "No Followers to show")
          : ListView.builder(
        itemBuilder: (final BuildContext context, final int index) {
          return FollowerTile(
            follower: followers[index],
            refresh: refresh,
          );
        },
        itemCount: followers.length,
      ),
    );
  }
}

///
class FollowerTile extends StatelessWidget {
  FollowerTile({
    required final this.follower,
    required final this.refresh,
    final Key? key,
  }) : super(key: key);

  Follower follower;
  Function refresh;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: <Widget>[
          PersonAvatar(
            avatarPhotoLink: follower.blog_avatar,
            shape: follower.blog_avatar_shape,
            blogID: follower.blog_id.toString(),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(follower.blog_username),
          ),
          TextButton(
            onPressed: () async {
              final dynamic res = await Api().unFollowBlog(follower.blog_id);
              if (res["meta"]["status"] == "200") {
                refresh();
                await showToast("Successful Operation!");
              } else {
                await showToast("Unsuccessful Operation!");
              }
            },
            child: const Text("Unfollow"),
          )
        ],
      ),
    );
  }
}