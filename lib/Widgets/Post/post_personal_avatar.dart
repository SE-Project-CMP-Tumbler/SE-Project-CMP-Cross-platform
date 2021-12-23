import "package:flutter/material.dart";

///Responsible for displaying user's avatar
class PersonAvatar extends StatefulWidget {
  ///Takes user's Photo link only
  const PersonAvatar({
    required final this.avatarPhotoLink,
    required final this.shape,
    final Key? key,
  }) : super(key: key);

  /// Link to Avatar Photo
  final String avatarPhotoLink;

  /// shape of the avatar
  final String shape;

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
        padding: const EdgeInsets.all(7),
        child: (widget.shape == "circle")
            ? CircleAvatar(
                backgroundImage: NetworkImage(widget.avatarPhotoLink),
                radius: 19,
              )
            : Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Image.network(
                  widget.avatarPhotoLink.isEmpty
                      ? "https://image.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg"
                      : widget.avatarPhotoLink,
                  fit: BoxFit.cover,

                ),
              ),
      ),
    );
  }
}
