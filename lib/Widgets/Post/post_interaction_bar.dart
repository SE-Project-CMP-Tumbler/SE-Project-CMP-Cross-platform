import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/posts.dart";
import "package:tumbler/Models/notes.dart";
import "package:tumbler/Screens/Notes/post_notes.dart";

Future<bool> getLikeStatus(final int postId, final int blogId) async {
  final Map<String, dynamic> res = await Api().getPostLikeStatus(postId);
  return res.values.single["response"]["like_status"];
}

///Class for interaction bar exists the bottom of each post in home page
//////Contains:
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

  late String blogId;
  late Notes _notes;
  late int _notesNum;
  bool _isLoved = false;
  bool onProcessing = false;
  bool isLoveButtonPressedAtleastOne = false;

  Future<void> likePost() async {
    await Posts.likePost(widget.postId);
  }

  Future<void> unlikePost() async {
    await Posts.unlikePost(widget.postId);
  }

  @override
  void initState() {
    //TODO(Waleed): get current blogID and use it to get current like status for a post.

    //widget.blogId = User.userID;
    // getLikeStatus(widget.postId % 4 + 1, 0).then((final bool result) {
    //   if (this.mounted) {
    //     setState(() {
    //       isLoved = result;
    //     });
    //   }
    // });

    _notes = Posts.getNotesForSinglePost(widget.postId);

    _notesNum =
        _notes.likes.length + _notes.replies.length + _notes.reblogs.length;

    super.initState();
    if (!widget.isMine) {
      getLikeStatus(widget.postID);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (isLoveButtonPressedAtleastOne) {
      if (_isLoved)
        likePost();
      else
        unlikePost();
    }
    super.dispose();
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
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.repeat,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () async {
              if (!_isLoved) {
                setState(() {
                  isLoveButtonPressedAtleastOne = true;
                  _isLoved = true;
                  _notesNum++;
                });
              } else {
                setState(() {
                  isLoveButtonPressedAtleastOne = true;
                  _isLoved = false;
                  _notesNum--;
                });
              }
            },
            icon: Icon(
              _isLoved ? Icons.favorite : Icons.favorite_border_outlined,
            ),
            color: _isLoved ? Colors.red : Colors.black,
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

void toNotesPage(final BuildContext context, final Notes notes) {
  Navigator.of(context).push(
    MaterialPageRoute<NotesPage>(
      builder: (final BuildContext context) => NotesPage(
        likesList: notes.likes,
        reblogsList: notes.reblogs,
        repliesList: notes.replies,
      ),
    ),
  );
}
