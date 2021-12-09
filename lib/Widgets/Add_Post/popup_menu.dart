import 'package:flutter/material.dart';

enum PostTypes { defaultPost, draftPost, privatePost }
PostTypes postType = PostTypes.defaultPost;

class PostTypeMenu extends StatefulWidget {
  const PostTypeMenu({Key? key}) : super(key: key);

  @override
  _PostTypeMenuState createState() => _PostTypeMenuState();
}

class _PostTypeMenuState extends State<PostTypeMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
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
              Container(
                child: Align(
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
              ),
            ]),
        Divider(
          thickness: 0.4,
          color: Colors.black45,
        ),
        ListTile(
          title: Row(children: [
            Icon(
              Icons.post_add,
              color: Colors.black,
            ),
            Text('   Post now'),
          ]),
          trailing: Radio(
            value: PostTypes.defaultPost,
            groupValue: postType,
            onChanged: (PostTypes? value) {
              setState(() {
                postType = value!;
              });
            },
          ),
        ),
        Divider(
          thickness: 0.3,
          color: Colors.black45,
        ),
        ListTile(
          title: Row(children: [
            Icon(
              Icons.save,
              color: Colors.black,
            ),
            Text('   Save as draft'),
          ]),
          trailing: Radio(
            value: PostTypes.draftPost,
            groupValue: postType,
            onChanged: (PostTypes? value) {
              setState(() {
                postType = value!;
              });
            },
          ),
        ),
        Divider(
          thickness: 0.32,
          color: Colors.black45,
        ),
        ListTile(
          title: Row(children: [
            Icon(
              Icons.lock,
              color: Colors.black,
            ),
            Text('   Post privately'),
          ]),
          trailing: Radio(
            value: PostTypes.privatePost,
            groupValue: postType,
            onChanged: (PostTypes? value) {
              setState(() {
                postType = value!;
              });
            },
          ),
        ),
        Divider(
          thickness: 0.32,
          color: Colors.black45,
        ),
      ],
    );
  }
}
