import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import 'package:tumbler/Models/post.dart';
import 'package:tumbler/Screens/Home_Page/home_page.dart';
import 'package:tumbler/Screens/Profile/profile_page.dart';
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
              Image.asset("assets/images/cat.png", width: _width,fit: BoxFit.fitWidth,),
              PersonalPostInteractionBar(notesNum: 11),
              /**Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: (){},
                      icon: Icon(CupertinoIcons.arrowshape_turn_up_right,
                        color: Colors.grey.shade800,size: 22,
                      ),
                      constraints: BoxConstraints.tight(
                          const Size(32,40),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(CupertinoIcons.chat_bubble,
                        color: Colors.grey.shade800,size: 22,
                      ),
                      constraints: BoxConstraints.tight(
                        const Size(32,40),
                      ),

                    ),
                    const SizedBox(width: 8,),

                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.repeat,
                        color: Colors.grey.shade800,size: 22,
                      ),
                      constraints: BoxConstraints.tight(
                        const Size(32,40),
                      ),

                    ),
                    const SizedBox(width: 8,),

                    IconButton(
                      onPressed: (){},
                      icon: Icon(CupertinoIcons.heart,
                        color: Colors.grey.shade800,size: 22,
                      ),
                      constraints: BoxConstraints.tight(
                        const Size(32,40),
                      ),
                    ),
                    const SizedBox(width: 8,),

                    IconButton(
                      onPressed: (){},
                      icon: Icon(CupertinoIcons.delete,
                        color: Colors.grey.shade800,size: 22,
                      ),
                      constraints: BoxConstraints.tight(
                        const Size(32,40),
                      ),
                    ),
                    const SizedBox(width: 8,),

                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.edit_outlined,
                        color: Colors.grey.shade800,size: 22,
                      ),
                      constraints: BoxConstraints.tight(
                        const Size(32,40),
                      ),

                    ),
                    const SizedBox(width: 16,),


                  ],
                ),
              ),**/
            ],
          ),
        );
  }
}
