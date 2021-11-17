import 'package:flutter/material.dart';
import 'package:tumbler/Screens/Home%20Page/home_page.dart';
import '../Post/post_interaction_bar.dart';
import '../Post/post_top_bar.dart';
import '../Post/post_recommendation_bar.dart';
import 'package:provider/provider.dart';
import '../../Providers/posts.dart';
import '../../Models/post.dart';

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
            avatarPhotoLink: widget.post.postAvatar,
            name: widget.post.postUserName,
          ),
          Container(
            width: double.infinity,
            height: 300,
            decoration:  BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                  widget.post.postBody),
            )),
          ),
          PostRecommendationBar(),
          PostInteractionBar(notesNum: widget.post.notesNum,)
        ],
      ),
    );
  }
}
