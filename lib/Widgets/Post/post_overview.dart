import "package:flutter/material.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Widgets/Post/html_viewer.dart";
import "package:tumbler/Widgets/Post/post_interaction_bar.dart";
import "package:tumbler/Widgets/Post/post_top_bar.dart";

///Shows the overview of the post in the home page
class PostOutView extends StatefulWidget {
  ///takes
  ///*Post model contains all data about the post
  const PostOutView({
    required final this.post,
    required final this.index,
    required final this.page,
    final this.isTagPost = false,
    final this.isDraft = false,
    final Key? key,
  }) : super(key: key);

  /// The Content of the Post
  final PostModel post;

  /// index of the post in the home page
  final int index;

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

  /// to indicate is this a tag post or not
  final bool isTagPost;

  /// to indicate is this post from dashboard
  final bool isDraft;

  @override
  _PostOutViewState createState() => _PostOutViewState();
}

class _PostOutViewState extends State<PostOutView> {
  List<PostModel> l = <PostModel>[];

  void traceBack() {
    for (final dynamic post in widget.post.traceBackPosts) {
      l.add(
        PostModel(
          postId: post["post_id"] ?? "",
          postBody: post["post_body"] ?? "",
          postStatus: "published",
          postType: post["post_type"] ?? "",
          blogId: post["blog_id"] ?? "",
          blogUsername: post["blog_username"] ?? "",
          blogAvatar: post["blog_avatar"] ?? "",
          blogAvatarShape: post["blog_avatar_shape"] ?? "",
          blogTitle: "",
          postTime: post["post_time"] ?? "",
          notes: 0,
          isLoved: false,
          isFollowed: (post["followed"] ?? true) as bool,
          traceBackPosts: <dynamic>[],
          isPinned: false,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setState(traceBack);
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        PostTopBar(
          avatarPhotoLink: widget.post.blogAvatar,
          avatarShape: widget.post.blogAvatarShape,
          name: widget.post.blogUsername,
          blogID: widget.post.blogId.toString(),
          isFollowed: widget.post.isFollowed,
          index: widget.index,
          postID: widget.post.postId.toString(),
          isReblog: false,
          isPinned: widget.post.isPinned,
        ),
        const Divider(
          color: Colors.grey,
        ),
        SizedBox(
          width: double.infinity,
          child: HtmlView(htmlData: widget.post.postBody),
        ),
        if (l.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (final BuildContext context, final int index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PostTopBar(
                      avatarPhotoLink: l[index].blogAvatar,
                      avatarShape: l[index].blogAvatarShape,
                      name: l[index].blogUsername,
                      blogID: l[index].blogId.toString(),
                      isFollowed: l[index].isFollowed,
                      index: index,
                      postID: l[index].postId.toString(),
                      isReblog: true,
                      isPinned: false,
                    ),
                    HtmlView(
                      htmlData: l[index].postBody,
                    ),
                    const Divider(
                      color: Colors.black,
                      height: 5,
                    ),
                  ],
                );
              },
              itemCount: l.length,
            ),
          ),
        PostInteractionBar(
          isMine: User.blogsNames.contains(widget.post.blogUsername),
          index: widget.index,
          postID: widget.post.postId,
          isDraft: widget.isDraft,
          page: widget.page,
        ),
        if (!widget.isTagPost)
          Container(
            height: 10,
            color: const Color.fromRGBO(
              0,
              25,
              53,
              1,
            ),
          )
        else
          Container(),
      ],
    );
  }
}
