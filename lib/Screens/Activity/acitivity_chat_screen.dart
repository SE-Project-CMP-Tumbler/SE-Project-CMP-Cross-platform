import 'package:carousel_slider/carousel_options.dart';
import "package:flutter/material.dart";

/// [blogType] is an Enumerator for specifing two different reblogs types
enum ActivityOrChat {
  ///reblogs with comments
  activity,

  ///reblogs without comments
  chat,
}

class ActivityAndChatScreen extends StatefulWidget {
  const ActivityAndChatScreen({Key? key}) : super(key: key);

  @override
  _ActivityAndChatScreenState createState() => _ActivityAndChatScreenState();
}

class _ActivityAndChatScreenState extends State<ActivityAndChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int currTabIndex = ActivityOrChat.activity.index;

  @override
  void initState() {
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
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (final BuildContext ctx, final int index) {
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Sunday, December 19",
                                  style: TextStyle(
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
                                children: const [
                                  LikeNotificationWidget(
                                    avatarUrl:
                                        "https://cdnb.artstation.com/p/assets/images/images/043/342/111/large/hadi-karimi-niet-1.jpg?1637004692",
                                    userName: "wemoOper",
                                  ),
                                  //TOBECONTINUED
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: 10,
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

class LikeNotificationWidget extends StatelessWidget {
  const LikeNotificationWidget({
    required final this.avatarUrl,
    required final this.userName,
    Key? key,
  }) : super(key: key);

  final String avatarUrl;
  final String userName;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          AvatarWithIcon(
            avatarUrl: avatarUrl,
            iconType: "like",
          ),
          const SizedBox(
            width: 10,
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: " liked your post",
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AvatarWithIcon extends StatelessWidget {
  AvatarWithIcon(
      {required final this.avatarUrl, required final this.iconType, Key? key})
      : super(key: key);

  final String avatarUrl;
  final String iconType;

  final Map<String, String> images = <String, String>{
    "reply": "icons8-speech-15.png",
    "like": "icons8-love-circled-15.png",
    "reblog": "icons8-repeat-15.png",
    "follow": "icons8-plus-+-15.png",
  };

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        overflow: Overflow.visible,
        children: [
          Image.network(
            avatarUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: -5,
            right: -5,
            child: Image.asset("./assets/images/${images[iconType]}"),
          )
        ],
      ),
    );
  }
}
