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
    final Key? key,
  }) : super(key: key);

  /// The Content of the Post
  final PostModel post;

  @override
  _PostOutViewState createState() => _PostOutViewState();
}

class _PostOutViewState extends State<PostOutView> {
  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        PostTopBar(
          avatarPhotoLink: widget.post.blogAvatar,
          avatarShape: widget.post.blogAvatarShape,
          name: widget.post.blogUsername,
          blogID: widget.post.blogId.toString(),
        ),
        const Divider(
          color: Colors.grey,
        ),
        SizedBox(
          width: double.infinity,
          child: HtmlView(htmlData: widget.post.postBody),
        ),
        PostInteractionBar(
          notesCount: widget.post.notes,
          postID: widget.post.postId,
          isMine: User.blogsNames.contains(widget.post.blogUsername),
        ),
        Container(
          height: 10,
          color: const Color.fromRGBO(
            0,
            25,
            53,
            1,
          ),
        )
      ],
    );
  }
}
