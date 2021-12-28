import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:like_button/like_button.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/notes.dart";
import "package:tumbler/Screens/Add_Post/edit_post.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";
import "package:tumbler/Screens/Notes/post_notes.dart";
import "package:tumbler/Screens/Reblog/reblog.dart";

///Class for interaction bar exists the bottom of each post in home page
//////Contains:
///1-Notes number
///2-buttons to Favorite and reblog and reply
class PostInteractionBar extends StatefulWidget {
  ///Constructor takes posts' notes
  const PostInteractionBar({
    required final this.index,
    required final this.isMine,
    final Key? key,
  }) : super(key: key);

  /// the index of the post in the page
  final int index;

  /// to indicate if the post is mine
  final bool isMine;

  @override
  _PostInteractionBarState createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  int index = 0;
  late int _notesNum;
  bool _isLoved = false;
  late int postID;
  bool onProcessing = false;
  bool isLoveButtonPressedAtLeastOne = false;

  /// Called when the user clicks on favorite icon button
  Future<void> likePost() async {
    final Map<String, dynamic> response =
        await Api().likePost(homePosts[index].postId);

    if (response["meta"]["status"] == "200") {
      homePosts[index].notes++;
      homePosts[index].isLoved = true;
    }
  }

  /// Called when the user clicks on un-favorite icon button (filled favorite)
  Future<void> unlikePost() async {
    final Map<String, dynamic> response =
        await Api().unlikePost(homePosts[index].postId);

    if (response["meta"]["status"] == "200") {
      homePosts[index].notes--;
      homePosts[index].isLoved = false;
    }
  }

  @override
  void initState() {
    index = widget.index;
    _notesNum = homePosts[index].notes;
    _isLoved = homePosts[index].isLoved;
    postID = homePosts[index].postId;
    super.initState();
  }

  @override
  void dispose() {
    if (isLoveButtonPressedAtLeastOne) {
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
                    builder: (final BuildContext context) => NotesPage(
                      postID: postID,
                      index: index,
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
                  MaterialPageRoute<NotesPage>(
                    builder: (final BuildContext context) => NotesPage(
                      postID: postID,
                      index: index,
                    ),
                  ),
                );
              },
              child: Text(
                "$_notesNum notes",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black45,
                ),
              ),
            ),
          ),
          IconButton(
            key: const ValueKey<String>("REBLOG"),
            onPressed: () {
              // TODO(Ziyad): Share
            },
            icon: const Icon(
              CupertinoIcons.arrowshape_turn_up_right,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<Reblog>(
                  builder: (final BuildContext context) => Reblog(
                    originalPost: homePosts[index].postBody,
                    parentPostId: homePosts[index].postId.toString(),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.repeat,
              color: Colors.black,
            ),
          ),
          IconButton(
            key: const ValueKey<String>("NOTES"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<NotesPage>(
                  builder: (final BuildContext context) => NotesPage(
                    postID: postID,
                    index: index,
                  ),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.conversation_bubble,
              color: Colors.black,
            ),
          ),
          if (!widget.isMine)
            LikeButton(
              isLiked: _isLoved,
              onTap: (final _) async {
                isLoveButtonPressedAtLeastOne = true;
                if (!_isLoved) {
                  setState(() {
                    _notesNum++;
                    _isLoved = true;
                  });
                } else {
                  setState(() {
                    _notesNum--;
                    _isLoved = false;
                  });
                }
                return _isLoved;
              },
              likeBuilder: (final bool isLoved) {
                final Color color = isLoved ? Colors.red : Colors.black;
                return Icon(
                  isLoved ? Icons.favorite : Icons.favorite_border_outlined,
                  color: color,
                );
              },
            ),
          if (widget.isMine)
            IconButton(
              onPressed: () async {
                final Map<String, dynamic> response =
                    await Api().deletePost(postID.toString());

                if (response["meta"]["status"] == "200") {
                  await showToast("Deleted");
                } else {
                  await showToast(response["meta"]["msg"]);
                }
              },
              icon: const Icon(
                CupertinoIcons.trash,
                color: Colors.black,
              ),
            ),
          if (widget.isMine)
            IconButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<EditPost>(
                    builder: (final BuildContext context) =>
                        EditPost(postID: postID.toString()),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
