import "package:flutter/material.dart";
import "package:tumbler/Widgets/Activity_Notifications/avatar_with_icon.dart";

///Widget that represents the reblog notification in activity page
class ReblogNotificationWidget extends StatelessWidget {
  /// Takes avatarUrl and userName
  const ReblogNotificationWidget({
    required final this.avatarUrl,
    required final this.userName,
    final Key? key,
  }) : super(key: key);

  /// avatar photo link to show
  final String avatarUrl;

  /// userName to show
  final String userName;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: <Widget>[
          AvatarWithIcon(
            avatarUrl: avatarUrl,
            iconType: "reblog",
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
                    const TextSpan(
                      text: " rebloged your post ",
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
