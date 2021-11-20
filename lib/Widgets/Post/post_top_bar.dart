import "package:flutter/material.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

///[PostTopBar] carries information about post owner
class PostTopBar extends StatefulWidget {
  /// Constructor
  const PostTopBar({
    required final this.showEditPostBottomSheet,
    required final this.avatarPhotoLink,
    required final this.name,
    final Key? key,
  }) : super(key: key);

  /// Function to show Edit Bottom Sheet
  final Function showEditPostBottomSheet;

  /// Link for the Avatar Photo
  final String avatarPhotoLink;

  /// Name of the user published the Post
  final String name;

  @override
  _PostTopBarState createState() => _PostTopBarState();
}

class _PostTopBarState extends State<PostTopBar> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Row(
        children: <Widget>[
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
          TextButton(
            onPressed: () {},
            child: const Text(
              "Follow",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => widget.showEditPostBottomSheet(context),
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
