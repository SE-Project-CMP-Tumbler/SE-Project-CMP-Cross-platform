import 'package:flutter/material.dart';
import 'package:tumbler/Screens/Home%20Page/home_page.dart';

import '../../Models/post.dart';
import '../Post/post_interaction_bar.dart';
import '../Post/post_top_bar.dart';
import '../general_widgets/html_viewer.dart';

///Shows the overview of the post in the home page
class PostOutView extends StatefulWidget {
  final Function showEditPostBottomSheet;
  final Post post;

  ///takes
  ///*showEditPostBottomSheet function that responsible for showing some options about the post by clicking on more vert icon
  ///*Post model contains all data about the post
  const PostOutView(
      {Key? key, required this.showEditPostBottomSheet, required this.post})
      : super(key: key);

  @override
  _PostOutViewState createState() => _PostOutViewState();
}

class _PostOutViewState extends State<PostOutView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostTopBar(
          showEditPostBottomSheet: showEditPostBottomSheet,
          avatarPhotoLink: widget.post.blogAvatar,
          name: widget.post.blogUsername,
        ),
        const Divider(
          color: Colors.grey,
        ),
        SizedBox(
          child: HtmlView(htmlData: widget.post.postBody),
          width: double.infinity,
        ),
        PostInteractionBar(
          notesNum: widget.post.likes.length +
              widget.post.reblogs.length +
              widget.post.replies.length,
        )
      ],
    );
  }
}
