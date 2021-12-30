// ignore_for_file: cascade_invocations

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/Activity_Notifications/ask.dart";
import "package:tumbler/Models/Activity_Notifications/follow.dart";
import "package:tumbler/Models/Activity_Notifications/mention.dart";
import "package:tumbler/Models/Activity_Notifications/reblog.dart";
import "package:tumbler/Models/Activity_Notifications/time_packet.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/ActivityAndChat/chat_out_view.dart";
import "package:tumbler/Widgets/Activity_Notifications/time_packet_contianer.dart";
import "package:tumbler/Widgets/Add_Post/dropdown_list.dart";
import "package:tumbler/Widgets/Exceptions_UI/empty_list_exception.dart";
import "package:tumbler/Widgets/Exceptions_UI/generic_exception.dart";

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
    with TickerProviderStateMixin {
  late TabController tabController;

  /// true when activity are loading.
  bool _isLoading = false;
  bool _error = false;
  bool _isEmpty = false;
  late AnimationController loadingSpinnerAnimationController;

  int currTabIndex = ActivityOrChat.activity.index;

  List<TimePacket> packets = <TimePacket>[];
  final List<dynamic> bigSack = <dynamic>[]; //list of notification models
  final DateFormat formatter = DateFormat("yyyy-MM-dd");

  Future<bool> getActivity() async {
    packets.clear();
    bigSack.clear();

    setState(() {
      _isEmpty = false;
      _isLoading = true;
      _error = false;
    });
    final Map<String, dynamic> response = await Api().getActivityNotifications(
      User.blogsIDs[User.currentProfile],
    );

    if (response["meta"]["status"] == "200") {
      final Map<String, dynamic> temp = response["response"]["notifications"];
      for (final String type in temp.keys) {
        final List<dynamic> tempList =
            response["response"]["notifications"][type] ?? <dynamic>[];
        for (final dynamic i in tempList) {
          if (type == "asks" ||
              type == "reblogs" ||
              type == "follows" ||
              type == "mentions_posts" ||
              type == "mentions_replies")
            bigSack.add(
              (type == "asks")
                  ? Ask(
                      dateTime: DateTime.parse(i["ask_time"]),
                      quesiton: i["question_body"],
                      avatarUrl: i["blog_avatar"],
                      userName: i["blog_username"],
                    )
                  : (type == "reblogs")
                      ? Reblog(
                          dateTime: DateTime.parse(i["post_time"]),
                          avatarUrl: i["blog_avatar"],
                          userName: i["blog_username"],
                        )
                      : (type == "follows")
                          ? Follow(
                              dateTime: DateTime.parse(i["follow_time"]),
                              avatarUrl: i["blog_avatar"],
                              userName: i["blog_username"],
                            )
                          : Mention(
                              dateTime: DateTime.parse(i["mention_time"]),
                              avatarUrl: i["blog_avatar"],
                              userName: i["blog_username"],
                            ),
            );
        }
      }

      for (int i = 0; i < bigSack.length; i++) {
        bigSack[i].dateTime =
            DateTime.parse(formatter.format(bigSack[i].dateTime));
      }

      bigSack.sort(
        (final dynamic a, final dynamic b) => a.dateTime.compareTo(b.dateTime),
      );

      final Map<DateTime, List<dynamic>> notificationMap =
          <DateTime, List<dynamic>>{};

      for (int i = 0; i < bigSack.length; i++) {
        if (notificationMap[bigSack[i].dateTime] == null) {
          notificationMap[bigSack[i].dateTime] = <dynamic>[bigSack[i]];
        } else {
          notificationMap[bigSack[i].dateTime]!.add(bigSack[i]);
        }
      }

      notificationMap.forEach(
        (final dynamic k, final dynamic v) =>
            packets.add(TimePacket(packetTime: k, packet: v)),
      );

      packets = packets.reversed.toList();

      setState(() {
        if (packets.isEmpty) {
          _isEmpty = true;
          _isLoading = false;
          _error = false;
        } else {
          _isEmpty = false;
          _isLoading = false;
          _error = false;
        }
      });

      return true;
    } else {
      await showToast(response["meta"]["msg"]);
      setState(() {
        _isEmpty = false;
        _isLoading = false;
        _error = true;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);

    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
    getActivity().then((final _) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
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
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          titleSpacing: 30,
          title: const ProfilesList(),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
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
            RefreshIndicator(
              onRefresh: getActivity,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: loadingSpinnerAnimationController.drive(
                          ColorTween(
                            begin: Colors.blueAccent,
                            end: Colors.red,
                          ),
                        ),
                      ),
                    )
                  : _error
                      ? const ErrorImage(msg: "Something went wrong ")
                      : _isEmpty
                          ? const EmptyBoxImage(msg: "No notifications to show")
                          : Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: ListView.builder(
                                      itemBuilder: (
                                        final BuildContext ctx,
                                        final int index,
                                      ) {
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
            ),
            const Center(
              child: ChatOutView(),
            )
          ],
        ),
      ),
    );
  }
}
