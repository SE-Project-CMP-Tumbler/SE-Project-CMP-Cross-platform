import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

// ignore: public_member_api_docs
class LikeTile extends StatefulWidget {
  ///
  const LikeTile({
    required final this.userName,
    required final this.blogTitle,
    required final this.blogAvatar,
    required final this.followStatus,
    required final this.avatarShape,
    required final this.blogID,
    required final this.updateFollowStatusLocally,
    final Key? key,
  }) : super(key: key);

  /// username of who had liked the post
  final String userName;

  /// blogTitle of who had liked the post
  final String blogTitle;

  /// blogAvatar of who had liked the post
  final String blogAvatar;

  /// followStatus of who had liked the post
  final bool followStatus;

  /// avatarShape of who had liked the post
  final String avatarShape;

  /// blog ID of who had liked the post
  final String blogID;

  ///update follow status locally
  final Function updateFollowStatusLocally;

  @override
  State<LikeTile> createState() => _LikeTileState();
}

class _LikeTileState extends State<LikeTile> {
  late bool _followStatus;

  @override
  void initState() {
    _followStatus = widget.followStatus;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        // ignore: avoid_redundant_argument_values
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          PersonAvatar(
            avatarPhotoLink: widget.blogAvatar,
            shape: widget.avatarShape,
            blogID: widget.blogID,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.blogTitle,
                    style: const TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: (User.blogsIDs[User.currentProfile] == widget.blogID)
                    ? Container()
                    : _followStatus
                        ? const Text(
                            "Unfollow",
                            style: TextStyle(fontSize: 18),
                          )
                        : const Text(
                            "Follow",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                onPressed: () async {
                  // make the request to follow/unfollow.
                  // if successufl : update the UI and update the data locally.
                  //else don't update the UI and show toast.
                  if (_followStatus) {
                    final Map<String, dynamic> response =
                        await Api().unFollowBlog(int.parse(widget.blogID));
                    if (response["meta"]["status"] == "200") {
                      setState(() {
                        _followStatus = false;
                      });
                      widget.updateFollowStatusLocally(widget.blogID, false);
                    } else {
                      await showToast("Failed operation,try again later");
                    }
                  } else {
                    final Map<String, dynamic> response =
                        await Api().followBlog(int.parse(widget.blogID));
                    if (response["meta"]["status"] == "200") {
                      setState(() {
                        _followStatus = true;
                      });
                      widget.updateFollowStatusLocally(widget.blogID, true);
                    } else {
                      await showToast("Failed operation,try again later");
                    }
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
