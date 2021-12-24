// ignore_for_file: public_member_api_docs

import "package:flutter/material.dart";

import "Package:tumbler/Widgets/Post/post_personal_avatar.dart";

class ReblogTileWithOutComments extends StatelessWidget {
  ///
  const ReblogTileWithOutComments({
    required final this.avatarUrl,
    required final this.userName,
    required final this.avatarShape,
    required final this.blogID,
    final Key? key,
  }) : super(key: key);

  /// Avatar Link
  final String avatarUrl;

  /// User Name
  final String userName;
  /// Shape
  final String avatarShape;

  /// Blog ID
  final String blogID;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            PersonAvatar(
              avatarPhotoLink: avatarUrl,
              shape: avatarShape,
              blogID: blogID,
            ),
            const SizedBox(
              width: 1,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                userName,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
