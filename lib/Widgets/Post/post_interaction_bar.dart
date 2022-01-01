import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:like_button/like_button.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/notes.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Add_Post/edit_post.dart";
import "package:tumbler/Screens/Add_Post/reblog_post.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";
import "package:tumbler/Screens/Notes/post_notes.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";
import "package:tumbler/Screens/Profile/profile_search.dart";
import "package:tumbler/Screens/Search/recommended_posts.dart";
import "package:tumbler/Screens/Search/search_result.dart";
import "package:tumbler/Screens/Search/tag_posts.dart";
import "package:tumbler/Screens/Settings/show_draft.dart";

///Class for interaction bar exists the bottom of each post in home page
///Contains:
///1-Notes number
///2-buttons to Favorite and reblog and reply
class PostInteractionBar extends StatefulWidget {
  ///Constructor takes posts' notes
  const PostInteractionBar({
    required final this.index,
    required final this.page,
    required final this.isMine,
    required final this.isDraft,
    required final this.postID,
    final Key? key,
  }) : super(key: key);

  /// the index of the post in the page
  final int index;

  /// to indicate if the post is mine
  final bool isMine;

  /// indicate which list we propagate in
  /// page = 0 -> Home Page
  /// page = 1 -> Profile Posts
  /// page = 2 -> Profile Like Posts
  /// page = 3 -> Search Result Posts
  /// page = 4 -> Draft Posts
  /// page = 5 -> Recommend Posts
  /// page = 6 -> Profile Search Posts
  /// page = 7 -> Recent tag Posts
  /// page = 8 -> Top tag Posts
  final int page;

  /// to update notes
  final bool isDraft;

  /// Post ID
  final int postID;

  @override
  _PostInteractionBarState createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  int index = 0;
  late int _notesNum = 0;
  bool _isLoved = false;
  late int postID;
  bool onProcessing = false;
  bool isLoveButtonPressedAtLeastOne = false;
  String body = "";

  /// Called when the user clicks on favorite icon button
  Future<void> likePost() async {
    final Map<String, dynamic> response = await Api().likePost(postID);

    if (response["meta"]["status"] == "200") {
      // indicate which list we propagate in
      // page = 0 -> Home Page
      // page = 1 -> Profile Posts
      // page = 2 -> Profile Like Posts
      // page = 3 -> Search Result Posts
      // page = 4 -> Draft Posts
      // page = 5 -> Recommend Posts
      // page = 6 -> Profile Search Posts
      // page = 7 -> Recent tag Posts
      // page = 8 -> Top tag Posts
      if (widget.page == 0) {
        homePosts[index].notes++;
        homePosts[index].isLoved = true;
      } else if (widget.page == 1) {
        postsTabPosts[index].notes++;
        postsTabPosts[index].isLoved = true;
      } else if (widget.page == 2) {
        postsTabLiked[index].notes++;
        postsTabLiked[index].isLoved = true;
      } else if (widget.page == 3) {
        postsRes[index].notes++;
        postsRes[index].isLoved = true;
      } else if (widget.page == 4) {
        draftPosts[index].notes++;
        draftPosts[index].isLoved = true;
      } else if (widget.page == 5) {
        randomPosts[index].notes++;
        randomPosts[index].isLoved = true;
      } else if (widget.page == 6) {
        profileSearchPosts[index].notes++;
        profileSearchPosts[index].isLoved = true;
      } else if (widget.page == 7) {
        recentPosts[index].notes++;
        recentPosts[index].isLoved = true;
      } else if (widget.page == 8) {
        topPosts[index].notes++;
        topPosts[index].isLoved = true;
      }
    }
  }

  /// Called when the user clicks on un-favorite icon button (filled favorite)
  Future<void> unlikePost() async {
    final Map<String, dynamic> response = await Api().unlikePost(postID);

    if (response["meta"]["status"] == "200") {
      // indicate which list we propagate in
      // page = 0 -> Home Page
      // page = 1 -> Profile Posts
      // page = 2 -> Profile Like Posts
      // page = 3 -> Search Result Posts
      // page = 4 -> Draft Posts
      // page = 5 -> Recommend Posts
      // page = 6 -> Profile Search Posts
      // page = 7 -> Recent tag Posts
      // page = 8 -> Top tag Posts
      if (widget.page == 0) {
        homePosts[index].notes--;
        homePosts[index].isLoved = false;
      } else if (widget.page == 1) {
        postsTabPosts[index].notes--;
        postsTabPosts[index].isLoved = false;
      } else if (widget.page == 2) {
        postsTabLiked[index].notes--;
        postsTabLiked[index].isLoved = false;
      } else if (widget.page == 3) {
        postsRes[index].notes--;
        postsRes[index].isLoved = false;
      } else if (widget.page == 4) {
        draftPosts[index].notes--;
        draftPosts[index].isLoved = false;
      } else if (widget.page == 5) {
        randomPosts[index].notes--;
        randomPosts[index].isLoved = false;
      } else if (widget.page == 6) {
        profileSearchPosts[index].notes--;
        profileSearchPosts[index].isLoved = false;
      } else if (widget.page == 7) {
        recentPosts[index].notes--;
        recentPosts[index].isLoved = false;
      } else if (widget.page == 8) {
        topPosts[index].notes--;
        topPosts[index].isLoved = false;
      }
    }
  }

  @override
  void initState() {
    postID = widget.postID;

    index = widget.index;
    postID = widget.postID;
    // indicate which list we propagate in
    // page = 0 -> Home Page
    // page = 1 -> Profile Posts
    // page = 2 -> Profile Like Posts
    // page = 3 -> Search Result Posts
    // page = 4 -> Draft Posts
    // page = 5 -> Recommend Posts
    // page = 6 -> Profile Search Posts
    // page = 7 -> Recent tag Posts
    // page = 8 -> Top tag Posts
    if (widget.page == 0) {
      _notesNum = homePosts[index].notes;
      _isLoved = homePosts[index].isLoved;
      postID = homePosts[index].postId;
      body = homePosts[index].postBody;
    } else if (widget.page == 1) {
      _notesNum = postsTabPosts[index].notes;
      _isLoved = postsTabPosts[index].isLoved;
      postID = postsTabPosts[index].postId;
      body = postsTabPosts[index].postBody;
    } else if (widget.page == 2) {
      _notesNum = postsTabLiked[index].notes;
      _isLoved = postsTabLiked[index].isLoved;
      postID = postsTabLiked[index].postId;
      body = postsTabLiked[index].postBody;
    } else if (widget.page == 3) {
      _notesNum = postsRes[index].notes;
      _isLoved = postsRes[index].isLoved;
      postID = postsRes[index].postId;
      body = postsRes[index].postBody;
    } else if (widget.page == 4) {
      _notesNum = draftPosts[index].notes;
      _isLoved = draftPosts[index].isLoved;
      postID = draftPosts[index].postId;
      body = draftPosts[index].postBody;
    } else if (widget.page == 5) {
      _notesNum = randomPosts[index].notes;
      _isLoved = randomPosts[index].isLoved;
      postID = randomPosts[index].postId;
      body = randomPosts[index].postBody;
    } else if (widget.page == 6) {
      _notesNum = profileSearchPosts[index].notes;
      _isLoved = profileSearchPosts[index].isLoved;
      postID = profileSearchPosts[index].postId;
      body = profileSearchPosts[index].postBody;
    } else if (widget.page == 7) {
      _notesNum = recentPosts[index].notes;
      _isLoved = recentPosts[index].isLoved;
      postID = recentPosts[index].postId;
      body = recentPosts[index].postBody;
    } else if (widget.page == 8) {
      _notesNum = topPosts[index].notes;
      _isLoved = topPosts[index].isLoved;
      postID = topPosts[index].postId;
      body = topPosts[index].postBody;
    }
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
          if (!widget.isDraft)
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
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  "assets/images/interactions.jpeg",
                  semanticLabel: "Notes",
                ),
              ),
            ),
          if (!widget.isDraft)
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<NotesPage>(
                      builder: (final BuildContext context) => NotesPage(
                        postID: postID,
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
          if (!widget.isDraft)
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<Reblog>(
                    builder: (final BuildContext context) => Reblog(
                      originalPost: body,
                      parentPostId: postID.toString(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.repeat,
                color: Colors.black,
              ),
            ),
          if (!widget.isDraft)
            IconButton(
              key: const ValueKey<String>("NOTES"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<NotesPage>(
                    builder: (final BuildContext context) => NotesPage(
                      postID: postID,
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
          if (widget.isMine && !widget.isDraft)
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
          if (widget.isMine && widget.isDraft)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () async {
                  final Map<String, dynamic> response =
                      await Api().changePostStatus(
                    widget.postID.toString(),
                    User.blogsIDs[User.currentProfile],
                  );

                  if (response["meta"]["status"] == "200") {
                    await showToast("Posted");
                    Navigator.of(context).pop();
                  } else
                    await showToast(response["meta"]["msg"]);
                },
                child: const Text(
                  "Post",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black45,
                  ),
                ),
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
