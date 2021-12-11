import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import 'package:tumbler/Models/post.dart';
import 'package:tumbler/Screens/Home_Page/home_page.dart';
import 'package:tumbler/Screens/Profile/profile_page.dart';
import 'package:tumbler/Widgets/Post/html_viewer.dart';
import 'package:tumbler/Widgets/Post/personal_post_interaction_bar.dart';
import 'package:tumbler/Widgets/Post/personal_post_top_bar.dart';
import 'package:tumbler/Widgets/Post/post_top_bar.dart';
/// for the 'Posts' tab in ProfilePage
class PersonalPost extends StatefulWidget {
  /// constructor
  ///takes
  ///*showEditPostBottomSheet function that responsible for showing
  ///some options about the post by clicking on more vert icon
  ///*Post model contains all data about the post
  const PersonalPost({
    required final this.showEditPostBottomSheet,
    required final this.post,
    final Key? key,
  }) : super(key: key);

  /// to be passed to [PostTopBar]
  final Function showEditPostBottomSheet;

  /// The Content of the Post
  final Post post;

  @override
  _PersonalPostState createState() => _PersonalPostState();
}

class _PersonalPostState extends State<PersonalPost> {
  @override
  Widget build(final BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // tumbler user name and profile pic and options
              PersonalPostTopBar(
                showEditPostPersonalBottomSheet: showEditPostProfileBottomSheet,
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
              PersonalPostInteractionBar(notesNum: 11),

            ],
          ),
        );
  }
}
