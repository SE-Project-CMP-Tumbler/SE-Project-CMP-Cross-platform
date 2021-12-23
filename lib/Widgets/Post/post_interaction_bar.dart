import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:like_button/like_button.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Screens/Notes/post_notes.dart";

///Class for interaction bar exists the bottom of each post in home page
///
///holds:
///1-Notes number
///2-buttons to Favorite and reblog and reply
class PostInteractionBar extends StatefulWidget {
  ///Constructor takes posts' notes
  const PostInteractionBar({
    required final this.notesCount,
    required final this.postID,
    required final this.isMine,
    final Key? key,
  }) : super(key: key);

  /// ID of this Post
  final int postID;

  /// The Number of notes of this post
  final int notesCount;

  /// true if the post is mine
  final bool isMine;

  @override
  _PostInteractionBarState createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  bool isLoved = false;

  Future<void> getLikeStatus(final int postId) async {
    final Map<String, dynamic> res = await Api().getPostLikeStatus(postId);
    if (mounted && res["meta"]["status"] == "200")
      setState(
        () => isLoved = (res["response"]["like_status"] ?? false) as bool,
      );
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isMine) {
      getLikeStatus(widget.postID);
    }
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
                  MaterialPageRoute<Notes>(
                    builder: (final BuildContext context) => Notes(
                      postID: widget.postID,
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
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<Notes>(
                    builder: (final BuildContext context) => Notes(
                      postID: widget.postID,
                    ),
                  ),
                );
              },
              child: Text(
                "${widget.notesCount} notes",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black45,
                ),
              ),
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              CupertinoIcons.arrowshape_turn_up_right,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<Notes>(
                  builder: (final BuildContext context) => Notes(
                    postID: widget.postID,
                  ),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.conversation_bubble,
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
          if (!widget.isMine)
            LikeButton(
              isLiked: isLoved,
              // onTap: (final bool x){
              // TODO(Waleed): Make the Request
              // },
              likeBuilder: (final bool isLoved) {
                final Color color = isLoved ? Colors.red : Colors.black;
                return Icon(
                  isLoved ? Icons.favorite : Icons.favorite_border_outlined,
                  color: color,
                );
              },
            ),
          if (widget.isMine)
            const IconButton(
              onPressed: null,
              icon: Icon(
                CupertinoIcons.trash,
                color: Colors.black,
              ),
            ),
          if (widget.isMine)
            const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.edit_outlined,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
