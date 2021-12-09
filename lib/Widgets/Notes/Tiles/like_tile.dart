import "package:flutter/material.dart";
import '../../Post/post_personal_avatar.dart';


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

  final String userName;
  final String blogTitle;
  final String blogAvatar;
  final bool followStatus;
  final String avatarShape;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PersonAvatar(avatarPhotoLink: blogAvatar, shape: avatarShape),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    blogTitle,
                    style: const TextStyle(color: Colors.black45),
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