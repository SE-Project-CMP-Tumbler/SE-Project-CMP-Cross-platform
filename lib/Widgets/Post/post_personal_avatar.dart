import "package:flutter/material.dart";

///Responsible for displaying user's avatar
class PersonAvatar extends StatefulWidget {
  ///Takes user's Photo link only
  const PersonAvatar({
    required final this.avatarPhotoLink,
    final Key? key,
  }) : super(key: key);

  /// Link to Avatar Photo
  final String avatarPhotoLink;

  @override
  _PersonAvatarState createState() => _PersonAvatarState();
}

class _PersonAvatarState extends State<PersonAvatar> {
  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO(Waleed): Navigate to user's profile
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 40,
          width: 40,
          child: Image.network(widget.avatarPhotoLink, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
