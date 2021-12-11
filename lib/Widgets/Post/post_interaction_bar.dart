// ignore_for_file: must_be_immutable, public_member_api_docs, lines_longer_than_80_chars

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:like_button/like_button.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Screens/Notes/post_notes.dart";

Future<bool> getLikeStatus(final int postId, final int blogId) async {
  Map<String, dynamic> res = await Api().getPostLikeStatus(postId);
  return res.values.single["response"]["like_status"];
}

///Class for interaction bar exists the bottom of each post in home page
///
///holds:
///1-Notes number
///2-buttons to Favorite and reblog and reply
class PostInteractionBar extends StatefulWidget {
  ///Constructor takes posts' notes
  PostInteractionBar({
    required final this.likes,
    required final this.reblogs,
    required final this.replies,
    required final this.postId,
    final Key? key,
  }) : super(key: key);

  List<dynamic> likes = <dynamic>[];
  List<dynamic> reblogs = <dynamic>[];
  List<dynamic> replies = <dynamic>[];

  final int postId;
  late String blogId;
  bool isLoved = false;

  @override
  _PostInteractionBarState createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

  @override
  void initState() {
    //TODO(Waleed): get current blogID and use it to get current like status for a post.
    //widget.blogId = User.userID;

    getLikeStatus(widget.postId % 4 + 1, 0).then((final bool result) {
      if (this.mounted) {
        setState(() {
          widget.isLoved = result;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<NotesPage>(
                    builder: (final BuildContext context) => NotesPage(
                      likesList: widget.likes,
                      reblogsList: widget.reblogs,
                      repliesList: widget.replies,
                    ),
                  ),
                );
              },
              child: Image.asset(
                "assets/images/interactions.jpeg",
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${numFormatter.format(widget.likes.length + widget.replies.length + widget.reblogs.length)} notes",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black45,
              ),
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.reply,
              color: Colors.black,
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.repeat,
              color: Colors.black,
            ),
          ),
          LikeButton(
            isLiked: widget.isLoved,
            likeBuilder: (final bool isLoved) {
              final Color color = isLoved ? Colors.red : Colors.black;
              return Icon(
                isLoved ? Icons.favorite : Icons.favorite_border_outlined,
                color: color,
              );
            },
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.add_comment_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
