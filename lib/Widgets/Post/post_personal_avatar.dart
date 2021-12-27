import "package:flutter/material.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";

///Responsible for displaying user's avatar
class PersonAvatar extends StatefulWidget {
  ///Takes user's Photo link only
  const PersonAvatar({
    required final this.avatarPhotoLink,
    required final this.shape,
    required final this.blogID,
    final Key? key,
  }) : super(key: key);

  /// Link to Avatar Photo
  final String avatarPhotoLink;

  /// shape of the avatar
  final String shape;

  /// Blog ID
  final String blogID;

  @override
  _PersonAvatarState createState() => _PersonAvatarState();
}

class _PersonAvatarState extends State<PersonAvatar> {
  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<ProfilePage>(
            builder: (final BuildContext context) => ProfilePage(
              blogID: widget.blogID,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: (widget.shape == "circle")
                ? const BorderRadius.all(
                    Radius.circular(20),
                  )
                : null,
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
