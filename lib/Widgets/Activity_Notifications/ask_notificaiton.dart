import "package:flutter/material.dart";
import "package:tumbler/Widgets/Activity_Notifications/avatar_with_icon.dart";

///widget that represents the ask notification showing up in the activity page
class AskNotificationWidget extends StatelessWidget {
  ///takes the avatar url of the one asked the question
  const AskNotificationWidget({
    required final this.avatarUrl,
    required final this.askingUserName,
    required final this.question,
    final Key? key,
  }) : super(key: key);

  /// avatar url of the one asked the question
  final String avatarUrl;

  ///the user name of the one asked the question
  final String askingUserName;

  /// the question asked
  final String question;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: <Widget>[
          AvatarWithIcon(
            avatarUrl: avatarUrl,
            iconType: "ask",
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
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
                        text: askingUserName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: " asked you:\n",
                      ),
                      TextSpan(
                        text: question,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Answer",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
