// ignore_for_file: cascade_invocations

import "package:flutter/material.dart";
import "package:tumbler/Models/Activity_Notifications/ask.dart";
import "package:tumbler/Models/Activity_Notifications/follow.dart";
import "package:tumbler/Models/Activity_Notifications/like.dart";
import "package:tumbler/Models/Activity_Notifications/mention.dart";
import "package:tumbler/Models/Activity_Notifications/reblog.dart";
import "package:tumbler/Models/Activity_Notifications/reply.dart";
import "package:tumbler/Models/Activity_Notifications/time_packet.dart";

import "package:tumbler/Widgets/Activity_Notifications/time_packet_contianer.dart";

/// [blogType] is an Enumerator for specifing two different reblogs types
enum ActivityOrChat {
  ///reblogs with comments
  activity,

  ///reblogs without comments
  chat,
}

///Activity and Chat screen
class ActivityAndChatScreen extends StatefulWidget {
  ///
  const ActivityAndChatScreen({final Key? key}) : super(key: key);

  @override
  _ActivityAndChatScreenState createState() => _ActivityAndChatScreenState();
}

class _ActivityAndChatScreenState extends State<ActivityAndChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int currTabIndex = ActivityOrChat.activity.index;

  String photo =
      "https://cdnb.artstation.com/p/assets/images/images/043/342/111/large/hadi-karimi-niet-1.jpg?1637004692";

  List<TimePacket> packets = <TimePacket>[];

  @override
  void initState() {
    ////////////TEST////////TEST////////TEST//////////TEST////////////////TEST////
    ///////////////TEST////////TEST////////TEST//////////TEST////////////////TEST/
    ///////////////TEST////////TEST////////TEST//////////TEST////////////////TEST/

    List<dynamic> l = [];
    l.add(
      Reply(
        dateTime: DateTime(2020, 9, 8),
        reply: "How awesome you are!",
        avatarUrl: photo,
        userName: "Salama",
      ),
    );
    l.add(
      Follow(
        dateTime: DateTime(2021, 9, 8),
        avatarUrl: photo,
        userName: "Salama",
      ),
    );
    l.add(
      Like(
        dateTime: DateTime(2000, 9, 8),
        avatarUrl: photo,
        userName: "Salama",
      ),
    );
    l.add(
      Mention(
        dateTime: DateTime(1999, 9, 8),
        avatarUrl: photo,
        userName: "Salama",
      ),
    );
    l.add(
      Reblog(
        dateTime: DateTime(2015, 9, 8),
        avatarUrl: photo,
        userName: "Salama",
      ),
    );
    l.add(
      Ask(
        dateTime: DateTime(2015, 9, 8),
        quesiton: "How are you?",
        avatarUrl: photo,
        userName: "Salama",
      ),
    );

    l.sort(
      (final dynamic a, final dynamic b) => a.dateTime.compareTo(b.dateTime),
    );

    Map<DateTime, List<dynamic>>? notificationMap = {};

    for (int i = 0; i < l.length; i++) {
      if (notificationMap[l[i].dateTime] == null) {
        notificationMap[l[i].dateTime] = <dynamic>[l[i]];
      } else {
        notificationMap[l[i].dateTime]!.add(l[i]);
      }
    }

    notificationMap.forEach(
      (final dynamic k, final dynamic v) =>
          packets.add(TimePacket(packetTime: k, packet: v)),
    );

    packets = packets.reversed.toList();

    ////////////TEST////////TEST////////TEST//////////TEST////////////////TEST/
    ///////////////TEST////////TEST////////TEST//////////TEST////////////////TEST/
    ///////////////TEST////////TEST////////TEST//////////TEST////////////////TEST/

    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar get _tabBar => TabBar(
        controller: tabController,
        onTap: (final _) {
          setState(() {
            currTabIndex = tabController.index;
          });
        },
        tabs: <Widget>[
          SizedBox(
            height: 40,
            child: Center(
              child: Text(
                "Activity",
                style: TextStyle(
                  color: (currTabIndex == ActivityOrChat.activity.index)
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Center(
              child: Text(
                "Chat",
                style: TextStyle(
                  color: (currTabIndex == ActivityOrChat.chat.index)
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
          titleSpacing: 30,
          title: const Text(
            "Drop list... ",
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.more_vert),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(color: Colors.white, child: _tabBar),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (final BuildContext ctx, final int index) {
                        return TimePacketContainer(
                          packetTime: packets[index].packetTime,
                          notificaitons: packets[index].packet,
                        );
                      },
                      itemCount: packets.length,
                    ),
                  )
                ],
              ),
            ),
            const Center(
              child: Text("Chat Page"),
            )
          ],
        ),
      ),
    );
  }
}
