import "package:flutter/material.dart";
import "package:intl/intl.dart";

/// [Notes]
class Notes extends StatefulWidget {
  ///
  Notes({
    required final this.likes,
    required final this.reblogs,
    required final this.replies,
    final Key? key,
  }) : super(key: key);

  ///
  List<dynamic> likes = <dynamic>[];

  ///
  List<dynamic> reblogs = <dynamic>[];

  ///
  List<dynamic> replies = <dynamic>[];

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar get _tabBar => TabBar(
        controller: tabController,
        indicatorColor: (tabController.index == 0)
            ? Colors.blue
            : (tabController.index == 1)
                ? Colors.lightGreen
                : Colors.red,
        onTap: (_) {
          setState(() {});
        },
        tabs: <Widget>[
          CustomizedTab(
            iconType: Icons.comment,
            number: widget.replies.length,
            color: Colors.blue,
            currIndex: tabController.index,
            myIndex: 0,
          ),
          CustomizedTab(
            iconType: Icons.repeat,
            number: widget.reblogs.length,
            color: Colors.green,
            currIndex: tabController.index,
            myIndex: 1,
          ),
          CustomizedTab(
            iconType: Icons.favorite_outline_outlined,
            number: widget.likes.length,
            color: Colors.red,
            currIndex: tabController.index,
            myIndex: 2,
          ),
        ],
      );

  NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
          titleSpacing: 30,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "${numFormatter.format(
                  widget.likes.length +
                      widget.replies.length +
                      widget.reblogs.length,
                )} notes",
              ),
            ],
          ),
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
              child: ListView.builder(
                itemBuilder: (final BuildContext ctx, final int index) {
                  return ReplyTile(
                    commentText: widget.replies[index]["reply_text"],
                    userName: widget.replies[index]["blog_username"],
                    photoUrl: widget.replies[index]["blog_avatar"],
                  );
                },
                itemCount: widget.replies.length,
              ),
            ),
            const Center(
              child: Text("favorites here"),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: (final BuildContext ctx, final int index) {
                  return likeTile(
                    blogAvatar: widget.likes[index]["blog_avatar"],
                    blogTitle: widget.likes[index]["blog_title"],
                    followStatus: widget.likes[index]["followed"],
                    userName: widget.likes[index]["blog_username"],
                  );
                },
                itemCount: widget.likes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class likeTile extends StatelessWidget {
  ///
  const likeTile({
    required final this.userName,
    required final this.blogTitle,
    required final this.blogAvatar,
    required final this.followStatus,
    final Key? key,
  }) : super(key: key);

  final String userName;
  final String blogTitle;
  final String blogAvatar;
  final bool followStatus;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(blogAvatar),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    blogTitle,
                    style: const TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: followStatus
                    ? const Text(
                        "Unfollow",
                        style: TextStyle(fontSize: 18),
                      )
                    : const Text(
                        "Follow",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomizedTab extends StatelessWidget {
  ///
  CustomizedTab({
    required final this.number,
    required final this.iconType,
    required final this.color,
    required final this.currIndex,
    required final this.myIndex,
    final Key? key,
  }) : super(key: key);

  ///
  final int number;

  ///
  final IconData iconType;

  ///
  final Color color;

  ///
  final int? currIndex;

  ///
  final int myIndex;

  ///
  NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconType,
              color: (currIndex == myIndex) ? color : Colors.grey,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              numFormatter.format(number),
              style: TextStyle(
                  color: (currIndex == myIndex)
                      ? color.withOpacity(1)
                      : Colors.grey,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyTile extends StatelessWidget {
  ///
  const ReplyTile({
    required final this.photoUrl,
    required final this.userName,
    required final this.commentText,
    final Key? key,
  }) : super(key: key);

  ///
  final String photoUrl;

  ///
  final String userName;

  ///
  final String commentText;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(photoUrl),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      commentText,
                      maxLines: 1000,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
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
