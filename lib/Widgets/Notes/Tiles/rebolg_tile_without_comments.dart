// ignore_for_file: public_member_api_docs

import "package:flutter/material.dart";

import "Package:tumbler/Widgets/Post/post_personal_avatar.dart";

class ReblogTileWithOutComments extends StatelessWidget {
  ///
  const ReblogTileWithOutComments({
    required final this.avatartUrl,
    required final this.userName,
    required final this.avatarShape,
    final Key? key,
  }) : super(key: key);

  ///
  final String avatartUrl;

  ///
  final String userName;

  ///
  final String avatarShape;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            PersonAvatar(avatarPhotoLink: avatartUrl, shape: avatarShape),
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
