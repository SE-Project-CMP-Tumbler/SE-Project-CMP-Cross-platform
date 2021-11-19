import 'package:flutter/material.dart';
import 'package:tumbler/Screens/Home%20Page/home_page.dart';
import '../Post/post_interaction_bar.dart';
import '../Post/post_top_bar.dart';
import '../../Models/post.dart';
import '../general_widgets/html_viewer.dart';

class PostOutView extends StatefulWidget {
  Function showEditPostBottomSheet;
  Post post;
  PostOutView(
      {Key? key, required this.showEditPostBottomSheet, required this.post})
      : super(key: key);

  @override
  _PostOutViewState createState() => _PostOutViewState();
}

class _PostOutViewState extends State<PostOutView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PostTopBar(
            showEditPostBottomSheet: showEditPostBottomSheet,
            avatarPhotoLink: widget.post.blogAvatar,
            name: widget.post.blogUsername,
          ),
          Container(
            child:HtmlView(htmlData: widget.post.postBody),
            width: double.infinity,
          ),
          //PostRecommendationBar(),
          PostInteractionBar(notesNum: widget.post.likes.length +widget.post.reblogs.length+widget.post.replies.length,)
        ],
      ),
    );
  }
}
