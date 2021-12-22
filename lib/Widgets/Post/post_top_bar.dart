import "package:flutter/material.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

///[PostTopBar] carries information about post owner
class PostTopBar extends StatefulWidget {
  /// Constructor
  const PostTopBar({
    required final this.avatarPhotoLink,
    required final this.name,
    final Key? key,
  }) : super(key: key);

  /// Link for the Avatar Photo
  final String avatarPhotoLink;

  /// Name of the user published the Post
  final String name;

  @override
  _PostTopBarState createState() => _PostTopBarState();
}

class _PostTopBarState extends State<PostTopBar> {
  /// Shows modal bottom sheet when
  /// the user clicks on more vert icon button in a post.
  void showEditPostBottomSheet(final BuildContext ctx) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: ctx,
      builder: (final _) {
        return Container(
          height: 200,
          color: Colors.black45,
          child: SingleChildScrollView(
            child: (widget.name == User.blogsNames[User.currentProfile])
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        onTap: () {},
                        title: const Text(
                          "Report sensitive content",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        title: const Text(
                          "Repost spam",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        title: const Text(
                          "Report something else",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        title: const Text(
                          "Copy link",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  )
                : Column( // if it is my post
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          // TODO(Ziyad): make the request
                        },
                        title: const Text(
                          "Pin Post",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        title: const Text(
                          "Mute notifications",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        title: const Text(
                          "Copy link",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Row(
        children: <Widget>[
          PersonAvatar(
            avatarPhotoLink: widget.avatarPhotoLink,
            shape: "square",
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
                onPressed: () => showEditPostBottomSheet(context),
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
