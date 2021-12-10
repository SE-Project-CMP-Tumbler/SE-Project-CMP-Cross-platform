import "package:flutter/material.dart";

/// Type of Post
enum PostTypes {
  /// Default Post type (published)
  defaultPost,
  /// When Saved as Draft
  draftPost,
  /// When Posted as private
  privatePost
}

/// the current post type
PostTypes postType = PostTypes.defaultPost;

/// Post Type Menu
class PostTypeMenu extends StatefulWidget {
  /// Constructor
  const PostTypeMenu({final Key? key}) : super(key: key);

  @override
  _PostTypeMenuState createState() => _PostTypeMenuState();
}

class _PostTypeMenuState extends State<PostTypeMenu> {
  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Text(
                  "             Post options                         ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ),
              //Spacer(),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Done"),
                ),
              ),
            ],),
        const Divider(
          thickness: 0.4,
          color: Colors.black45,
        ),
        ListTile(
          title: Row(children: const <Widget>[
            Icon(
              Icons.post_add,
              color: Colors.black,
            ),
            Text("   Post now"),
          ],),
          trailing: Radio<PostTypes>(
            value: PostTypes.defaultPost,
            groupValue: postType,
            onChanged: (final PostTypes? value) {
              setState(() {
                postType = value!;
              });
            },
          ),
        ),
        const Divider(
          thickness: 0.3,
          color: Colors.black45,
        ),
        ListTile(
          title: Row(children: const <Widget>[
            Icon(
              Icons.save,
              color: Colors.black,
            ),
            Text("   Save as draft"),
          ],),
          trailing: Radio<PostTypes>(
            value: PostTypes.draftPost,
            groupValue: postType,
            onChanged: (final PostTypes? value) {
              setState(() {
                postType = value!;
              });
            },
          ),
        ),
        const Divider(
          thickness: 0.32,
          color: Colors.black45,
        ),
        ListTile(
          title: Row(children: const <Widget>[
            Icon(
              Icons.lock,
              color: Colors.black,
            ),
            Text("   Post privately"),
          ],),
          trailing: Radio<PostTypes>(
            value: PostTypes.privatePost,
            groupValue: postType,
            onChanged: (final PostTypes? value) {
              setState(() {
                postType = value!;
              });
            },
          ),
        ),
        const Divider(
          thickness: 0.32,
          color: Colors.black45,
        ),
      ],
    );
  }
}