import "package:flutter/material.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

// ignore: public_member_api_docs
class LikeTile extends StatelessWidget {
  ///
  const LikeTile({
    required final this.userName,
    required final this.blogTitle,
    required final this.blogAvatar,
    required final this.followStatus,
    required final this.avatarShape,
    final Key? key,
  }) : super(key: key);

  /// username of who had liked the post
  final String userName;

  /// blogTitle of who had liked the post
  final String blogTitle;

  /// blogAvatar of who had liked the post
  final String blogAvatar;

  /// followStatus of who had liked the post
  final bool followStatus;

  /// avatarShape of who had liked the post
  final String avatarShape;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        // ignore: avoid_redundant_argument_values
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          PersonAvatar(avatarPhotoLink: blogAvatar, shape: avatarShape),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    blogTitle,
                    style: const TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: followStatus
                    ? const Text(
                        "Unfollow",
                        style: TextStyle(fontSize: 18),
                      )
                    : const Text(
                        "Follow",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
