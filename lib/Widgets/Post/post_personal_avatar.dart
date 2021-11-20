import 'package:flutter/material.dart';

///Responsiple for displaying user's avatar
class PersonAvatar extends StatefulWidget {
  final String avatarPhotoLink;

  ///Takes user's Photo link only
  const PersonAvatar({Key? key, required this.avatarPhotoLink})
      : super(key: key);

  @override
  _PersonAvatarState createState() => _PersonAvatarState();
}

class _PersonAvatarState extends State<PersonAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: Navigate to user's profile
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 40.0,
          width: 40.0,
          child: Image.network(widget.avatarPhotoLink, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
