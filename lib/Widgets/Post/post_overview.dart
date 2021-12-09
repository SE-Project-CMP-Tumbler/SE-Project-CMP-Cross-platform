import "package:flutter/material.dart";
import "package:tumbler/Models/post.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";
import "package:tumbler/Widgets/Post/html_viewer.dart";
import "package:tumbler/Widgets/Post/post_interaction_bar.dart";
import "package:tumbler/Widgets/Post/post_top_bar.dart";

///Shows the overview of the post in the home page
class PostOutView extends StatefulWidget {
  ///takes
  ///*showEditPostBottomSheet function that responsible for showing
  ///some options about the post by clicking on more vert icon
  ///*Post model contains all data about the post
  const PostOutView({
    required final this.showEditPostBottomSheet,
    required final this.post,
    final Key? key,
  }) : super(key: key);

  /// to be passed to [PostTopBar]
  final Function showEditPostBottomSheet;

  /// The Content of the Post
  final Post post;

  @override
  _PostOutViewState createState() => _PostOutViewState();
}

class _PostOutViewState extends State<PostOutView> {
  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        PostTopBar(
          showEditPostBottomSheet: showEditPostBottomSheet,
          avatarPhotoLink: widget.post.blogAvatar,
          name: widget.post.blogUsername,
        ),
        const Divider(
          color: Colors.grey,
        ),
        SizedBox(
          width: double.infinity,
          child: HtmlView(htmlData: widget.post.postBody),
        ),
        PostInteractionBar(
         likes:widget.post.likes,
         reblogs:widget.post.reblogs,
         replies:widget.post.replies,
        )
      ],
    );
  }
}
