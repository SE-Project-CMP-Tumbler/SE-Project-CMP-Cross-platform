// ignore_for_file: sort_constructors_first

import "package:flutter/material.dart";
import 'package:tumbler/Models/post.dart';
import 'package:tumbler/Widgets/Post/post_overview.dart';
// ignore: public_member_api_docs
class LikesTab extends StatefulWidget {
  // ignore: public_member_api_docs
  final Color secondaryTextColor;
  final List<Post> posts;
  // ignore: public_member_api_docs
  const LikesTab({ required final this.secondaryTextColor,
    required final this.posts,
    final Key? key,
    }) :
        super(key: key);

  @override
  _LikesTabState createState() => _LikesTabState();
}

class _LikesTabState extends State<LikesTab> {

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [
            Container(
              color: Colors.grey.shade300,
              height: 50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text("Everyone can see this page", textScaleFactor:1 ,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: TextButton(onPressed: (){}, child: Text("Change", style:
                  TextStyle(color: widget.secondaryTextColor ),),),
                )

              ],),
            ),
            const SizedBox(height: 20,),
            Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: PostOutView(
                    showEditPostBottomSheet:
                    (){},
                    post: widget.posts[0],
                  ),
                ),
            )
          ],
        ),
    );
  }
}
