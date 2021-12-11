import 'package:flutter/material.dart';
import 'package:tumbler/Widgets/Post/post_personal_avatar.dart';
/// the top bar of personal post in profile page
class PersonalPostTopBar extends StatefulWidget {
  /// Constructor
  const PersonalPostTopBar({
    required final this.showEditPostPersonalBottomSheet,
    required final this.avatarPhotoLink,
    required final this.name,
    final Key? key,
  }) : super(key: key);

  /// Function to show Edit Bottom Sheet
  final Function showEditPostPersonalBottomSheet;

  /// Link for the Avatar Photo
  final String avatarPhotoLink;

  /// Name of the user published the Post
  final String name;

  @override
  _PersonalPostTopBarState createState() => _PersonalPostTopBarState();
}

class _PersonalPostTopBarState extends State<PersonalPostTopBar> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Row(
        children: <Widget>[
          PersonAvatar(
            avatarPhotoLink: widget.avatarPhotoLink,shape:"square",
          ),
          Text(
            widget.name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () =>
                    widget.showEditPostPersonalBottomSheet(context),
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black87,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
