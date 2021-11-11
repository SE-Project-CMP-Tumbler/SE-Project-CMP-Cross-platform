import 'package:flutter/material.dart';
import '../Post/post_interaction_bar.dart';
import '../Post/post_top_bar.dart';
import '../Post/post_recommendation_bar.dart';

class PostOutView extends StatefulWidget {
  const PostOutView({Key? key}) : super(key: key);

  @override
  _PostOutViewState createState() => _PostOutViewState();
}

class _PostOutViewState extends State<PostOutView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PostTopBar(),
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                  "https://pbs.twimg.com/media/EiC-uBVX0AEfEIY.jpg"),
            )),
          ),
          PostRecommendationBar(),
          PostInteractionBar()
        ],
      ),
    );
  }
}
