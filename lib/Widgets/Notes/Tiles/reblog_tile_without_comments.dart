import "package:flutter/material.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";

import "Package:tumbler/Widgets/Post/post_personal_avatar.dart";

/// Widget of the Reblog without comment in the Notes
class ReblogTileWithOutComments extends StatelessWidget {
  /// Constructor
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<ProfilePage>(
                    builder: (final BuildContext context) => ProfilePage(
                      blogID: blogID,
                    ),
                  ),
                );
              },
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
