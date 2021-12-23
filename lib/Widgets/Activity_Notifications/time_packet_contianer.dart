import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:tumbler/Widgets/Activity_Notifications/ask_notificaiton.dart";
import "package:tumbler/Widgets/Activity_Notifications/follow_notification.dart";
import "package:tumbler/Widgets/Activity_Notifications/like_notification.dart";
import "package:tumbler/Widgets/Activity_Notifications/mention_notification.dart";
import "package:tumbler/Widgets/Activity_Notifications/reblog_notificaiton.dart";
import "package:tumbler/Widgets/Activity_Notifications/reply_notification.dart";

///[TimePacketContainer] is a contianer for notifications of the same time stamp
class TimePacketContainer extends StatelessWidget {
  ///Takes packet time and notifications list
  const TimePacketContainer({
    required final this.packetTime,
    required final this.notificaitons,
    final Key? key,
  }) : super(key: key);

  ///packet time to show in the header of the container
  final DateTime packetTime;

  ///list of notificaitons of different types to show
  final List<dynamic> notificaitons;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            DateFormat.MMMMEEEEd().format(packetTime).toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ),
        Divider(
          height: 10,
          thickness: 5,
          color: Colors.grey.withOpacity(0.1),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: notificaitons.map((final dynamic element) {
            return (element.type == "like")
                ? LikeNotificationWidget(
                    avatarUrl: element.avatarUrl,
                    userName: element.userName,
                  )
                : (element.type == "reblog")
                    ? ReblogNotificationWidget(
                        avatarUrl: element.avatarUrl,
                        userName: element.userName,
                      )
                    : (element.type == "mention")
                        ? MentionNotificationWidget(
                            avatarUrl: element.avatarUrl,
                            mentioningUserName: element.userName,
                          )
                        : (element.type == "ask")
                            ? AskNotificationWidget(
                                avatarUrl: element.avatarUrl,
                                askingUserName: element.userName,
                                question: element.quesiton,
                              )
                            : (element.type == "follow")
                                ? FollowNotificationWidget(
                                    userName: element.userName,
                                    avatarUrl: element.avatarUrl,
                                  )
                                : (element.type == "reply")
                                    ? ReplyNotificationWidget(
                                        avatarUrl: element.avatarUrl,
                                        replyingUserName: element.userName,
                                        reply: element.reply,
                                      )
                                    : const Placeholder();
          }).toList(),
        )
      ],
    );
  }
}
