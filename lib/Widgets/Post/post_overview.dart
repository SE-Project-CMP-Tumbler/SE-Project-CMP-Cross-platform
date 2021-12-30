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
    final this.isTagPost=false,
    final Key? key,
  }) : super(key: key);

  /// The Content of the Post
  final PostModel post;

  /// index of the post in the home page
  final int index;

  /// to indicate is this a tag post or not
  final bool isTagPost;
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
          isFollowed: (post["followed"] ?? false) as bool,
          traceBackPosts: <dynamic>[],
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
              border: Border.all(color: Colors.black),
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
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
        ),
        if (!widget.isTagPost) Container(
          height: 10,
          color: const Color.fromRGBO(
            0,
            25,
            53,
            1,
          ),
        ) else Container(),
      ],
    );
  }
}
