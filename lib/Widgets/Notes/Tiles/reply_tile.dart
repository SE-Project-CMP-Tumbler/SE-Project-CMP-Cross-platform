// ignore_for_file: public_member_api_docs

import "package:flutter/material.dart";
import "package:tumbler/Widgets/Post/html_viewer.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

class ReplyTile extends StatelessWidget {
  ///
  const ReplyTile({
    required final this.avatarUrl,
    required final this.userName,
    required final this.commentText,
    required final this.avatarShape,
    required final this.blogID,
    final Key? key,
  }) : super(key: key);

  /// Avatar Link
  final String avatarUrl;

  /// User Name
  final String userName;

  /// Comment Text
  final String commentText;

  /// Shape
  final String avatarShape;

  /// Blog ID
  final String blogID;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PersonAvatar(
            avatarPhotoLink: avatarUrl,
            shape: avatarShape,
            blogID: blogID,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                    HtmlView(
                      htmlData: "<p>$commentText</p>",
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
