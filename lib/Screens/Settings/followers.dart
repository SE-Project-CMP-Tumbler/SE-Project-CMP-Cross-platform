import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/followers_model.dart";
import "package:tumbler/Widgets/Exceptions_UI/empty_list_exception.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

/// Screen of My Followers
class MyFollowers extends StatefulWidget {
  /// Constructor
  const MyFollowers({final Key? key}) : super(key: key);

  @override
  _MyFollowersState createState() => _MyFollowersState();
}

class _MyFollowersState extends State<MyFollowers>
    with TickerProviderStateMixin {
  late List<dynamic> followers = <dynamic>[];
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
          blogAvatar: jsonData["blog_avatar"],
          blogID: jsonData["blog_id"],
          blogAvatarShape: jsonData["blog_avatar_shape"],
          blogUsername: jsonData["blog_username"],
        );
      }).toList();
    }

    for (int i = 0; i < followers.length; i++) {
      final Map<String, dynamic> res =
          await Api().isMyFollowing(followers[i].blogID);
      if (res["meta"]["status"] == "200") {
        followers[i].isFollowedByMe = res["response"]["followed"] ?? false;
      } else {
        await showToast("Unsuccessful operation!");
      }
    }

    setState(() {
      isLoading = false;
    });
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
                    );
                  },
                  itemCount: followers.length,
                ),
    );
  }
}

/// Widget Follower Tile
class FollowerTile extends StatefulWidget {
  /// Constructor
  const FollowerTile({
    required final this.follower,
    final Key? key,
  }) : super(key: key);

  /// Model of the follower
  final Follower follower;

  @override
  State<FollowerTile> createState() => _FollowerTileState();
}

class _FollowerTileState extends State<FollowerTile> {
  late bool isFollowedByMe;

  @override
  void initState() {
    isFollowedByMe = widget.follower.isFollowedByMe;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: <Widget>[
          PersonAvatar(
            avatarPhotoLink: widget.follower.blogAvatar,
            shape: widget.follower.blogAvatarShape,
            blogID: widget.follower.blogID.toString(),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(widget.follower.blogUsername),
          ),
          TextButton(
            onPressed: () async {
              if (isFollowedByMe) {
                final dynamic res =
                    await Api().unFollowBlog(widget.follower.blogID);
                if (res["meta"]["status"] == "200") {
                  await showToast("Successful unfollowing!");
                } else {
                  await showToast("Unsuccessful unfollowing!");
                }
                setState(() {
                  isFollowedByMe = false;
                });
              } else {
                final dynamic res =
                    await Api().followBlog(widget.follower.blogID);
                if (res["meta"]["status"] == "200") {
                  await showToast("Successful following");
                } else {
                  await showToast("Unsuccessful following!");
                }
                setState(() {
                  isFollowedByMe = true;
                });
              }
            },
            child:
                isFollowedByMe ? const Text("Unfollow") : const Text("Follow"),
          )
        ],
      ),
    );
  }
}
