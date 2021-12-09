import "package:flutter/material.dart";
import '../../Post/post_personal_avatar.dart';


class ReplyTile extends StatelessWidget {
  ///
  const ReplyTile({
    required final this.avatarUrl,
    required final this.userName,
    required final this.commentText,
    required final this.avatarShape,
    final Key? key,
  }) : super(key: key);

  ///
  final String avatarUrl;

  ///
  final String userName;

  ///
  final String commentText;

  ///
  final String avatarShape;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         PersonAvatar(avatarPhotoLink: avatarUrl, shape: avatarShape),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      commentText,
                      maxLines: 1000,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}