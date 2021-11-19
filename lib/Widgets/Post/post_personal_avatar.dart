import 'package:flutter/material.dart';


class PersonAvatar extends StatefulWidget {
  final String avatarPhotoLink;
  const PersonAvatar({Key? key, required this.avatarPhotoLink}) : super(key: key);

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
        child: Container(
          height: 40.0,
          width: 40.0,
          child: Image.network(widget.avatarPhotoLink, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
