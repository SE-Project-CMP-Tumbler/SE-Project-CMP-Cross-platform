import 'package:flutter/material.dart';
import './post_personal_avatar.dart';

class PostTopBar extends StatefulWidget {
  Function showEditPostBottomSheet;
  String avatarPhotoLink;
  String name;
  PostTopBar({
    Key? key,
    required this.showEditPostBottomSheet,
    required this.avatarPhotoLink,
    required this.name,
  }) : super(key: key);

  @override
  _PostTopBarState createState() => _PostTopBarState();
}

class _PostTopBarState extends State<PostTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PersonAvatar(
            avatarPhotoLink: widget.avatarPhotoLink,
          ),
          Text(
            widget.name,
            style: const TextStyle(
              color: Colors.black87,
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
            child: IconButton(
              onPressed: () => widget.showEditPostBottomSheet(context),
              icon: Icon(
                Icons.more_vert,
                color: Colors.black87,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
