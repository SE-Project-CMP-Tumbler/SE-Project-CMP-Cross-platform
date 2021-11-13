import 'package:flutter/material.dart';
import './post_personal_avatar.dart';

class PostTopBar extends StatefulWidget {
  Function showEditPostBottomSheet;
   PostTopBar({
    Key? key,
    required this.showEditPostBottomSheet,
  }) : super(key: key);

  @override
  _PostTopBarState createState() => _PostTopBarState();
}

class _PostTopBarState extends State<PostTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PersonAvatar(),
          const Text(
            "IRON MAN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          FlatButton(
              onPressed: () {},
              child: const Text(
                "Follow",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              )),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child:  IconButton(
              onPressed: ()=>widget.showEditPostBottomSheet(context),
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
