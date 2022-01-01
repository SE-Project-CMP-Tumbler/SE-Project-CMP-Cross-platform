import "package:flutter/material.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Widgets/Activity_Notifications/avatar_with_icon.dart";

/// Widget that represent the new following notification in activity page
class FollowNotificationWidget extends StatelessWidget {
  ///taked the user name and avatar url
  const FollowNotificationWidget({
    required final this.userName,
    required final this.avatarUrl,
    final Key? key,
  }) : super(key: key);

  /// avatar url of the new follower
  final String avatarUrl;

  /// the user name of the new follower
  final String userName;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: <Widget>[
          AvatarWithIcon(
            avatarUrl: avatarUrl,
            iconType: "follow",
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    //maxLines: 1000,
                    overflow: TextOverflow.ellipsis,
                    //softWrap: false,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          " started following @${User.blogsNames[User.currentProfile]}",
                    )
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
