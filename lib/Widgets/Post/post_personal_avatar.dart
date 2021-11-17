import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/posts.dart';

class PersonAvatar extends StatefulWidget {
  String avatarPhotoLink;
   PersonAvatar({Key? key, required this.avatarPhotoLink})
      : super(key: key);

  @override
  _PersonAvatarState createState() => _PersonAvatarState();
}

class _PersonAvatarState extends State<PersonAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 40.0,
            width: 40.0,
            child: Image.network(widget.avatarPhotoLink),
          ),
        ),
      ),
    );
  }
}
