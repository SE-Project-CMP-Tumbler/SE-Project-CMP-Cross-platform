import "package:flutter/material.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Widgets/Activity_Notifications/avatar_with_icon.dart";

///Widget that represents the mention notification showing up in the activity
///page
class MentionNotificationWidget extends StatelessWidget {
  ///takes the avatar url of the one mentioning and its user name
  const MentionNotificationWidget({
    required final this.avatarUrl,
    required final this.mentioningUserName,
    final Key? key,
  }) : super(key: key);

  /// avatar url of the one mentioning
  final String avatarUrl;

  /// the user name of the one mentioning
  final String mentioningUserName;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: <Widget>[
          AvatarWithIcon(
            avatarUrl: avatarUrl,
            iconType: "mention",
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black26,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
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
                        text: mentioningUserName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            " mentioned you in a post @${User.blogsNames[User.currentProfile]}",
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
