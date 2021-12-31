import "package:flutter/material.dart";
import "package:tumbler/Screens/Notes/post_notes.dart";
import "package:tumbler/Widgets/Activity_Notifications/avatar_with_icon.dart";

///Widget that represent the reply notification showing up in the activity page
class ReplyNotificationWidget extends StatelessWidget {
  /// takes avatar url of the one replied and replying user name and the reply
  /// itself
  const ReplyNotificationWidget({
    required final this.avatarUrl,
    required final this.replyingUserName,
    required final this.reply,
    required final this.postID,
    final Key? key,
  }) : super(key: key);

  /// postID to reply on
  final int postID;

  ///avatar photo url of who replied on a post
  final String avatarUrl;

  /// user name of the one who replied on the post
  final String replyingUserName;

  /// the reply typed
  final String reply;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        // ignore: avoid_redundant_argument_values
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AvatarWithIcon(
            avatarUrl: avatarUrl,
            iconType: "reply",
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
                        text: replyingUserName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: " replied on your post:\n",
                      ),
                      TextSpan(
                        text: reply,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<NotesPage>(
                  builder: (final BuildContext context) => NotesPage(
                    postID: postID,
                  ),
                ),
              );
            },
            child: const Text(
              "Reply",
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