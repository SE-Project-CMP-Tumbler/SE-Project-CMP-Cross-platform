import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../Widgets/Post/html_viewer.dart";
import "../../Widgets/Post/post_personal_avatar.dart";

enum blogsType {
  withComments,
  Others,
}

void showEditPostBottomSheet(final BuildContext ctx, final Enum currType,
    final Function changeBlogViewSection) {
  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    context: ctx,
    builder: (final _) {
      return Container(
        height: 150,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  if (currType != blogsType.withComments) {
                    changeBlogViewSection(blogsType.withComments);
                  }
                  Navigator.pop(ctx);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "Reblogs with comments",
                        style: TextStyle(
                          color: (currType == blogsType.withComments)
                              ? Colors.blue
                              : Colors.black87,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "Show reblogs with added comments and/or tags",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  if (currType != blogsType.Others) {
                    changeBlogViewSection(blogsType.Others);
                  }
                  Navigator.pop(ctx);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "Other reblogs",
                        style: TextStyle(
                          color: (currType == blogsType.Others)
                              ? Colors.blue
                              : Colors.black87,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "Show empty reblogs",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

/// [Notes]
class Notes extends StatefulWidget {
  ///
  Notes({
    required final this.likesList,
    required final this.reblogsList,
    required final this.repliesList,
    final Key? key,
  }) : super(key: key);

  ///
  List<dynamic> likesList = <dynamic>[];

  ///
  List<dynamic> reblogsList = <dynamic>[];
  List<dynamic> reblogsWithCommentsList = <dynamic>[];
  List<dynamic> reblogsWithOutCommentsList = <dynamic>[];

  ///
  List<dynamic> repliesList = <dynamic>[];

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> with SingleTickerProviderStateMixin {
  late TabController tabController;

  final replyController = TextEditingController();

  Enum blogTypeToShow = blogsType.withComments;

  void checkReplyText() {
    setState(() {});
  }

  void changeBlogViewSection(final Enum type) {
    setState(() {
      blogTypeToShow = type;
    });
  }

  @override
  void initState() {
    // spilt blogs recieved into to sub-categories
    for (int i = 0; i < widget.reblogsList.length; i++) {
      if (widget.reblogsList[i]["reblog_content"].isEmpty) {
        widget.reblogsWithOutCommentsList.add(widget.reblogsList[i]);
      } else {
        widget.reblogsWithCommentsList.add(widget.reblogsList[i]);
      }
    }

    super.initState();
    // Start listening to changes.
    replyController.addListener(checkReplyText);
    tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    tabController.dispose();
    replyController.dispose();
    super.dispose();
  }

  TabBar get _tabBar => TabBar(
        controller: tabController,
        indicatorColor: (tabController.index == 0)
            ? Colors.blue
            : (tabController.index == 1)
                ? Colors.lightGreen
                : Colors.red,
        onTap: (final _) {
          setState(() {});
        },
        tabs: <Widget>[
          CustomizedTab(
            iconType: Icons.comment,
            number: widget.repliesList.length,
            color: Colors.blue,
            currIndex: tabController.index,
            myIndex: 0,
          ),
          CustomizedTab(
            iconType: Icons.repeat,
            number: widget.reblogsList.length,
            color: Colors.green,
            currIndex: tabController.index,
            myIndex: 1,
          ),
          CustomizedTab(
            iconType: Icons.favorite_outline_outlined,
            number: widget.likesList.length,
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
                  widget.likesList.length +
                      widget.repliesList.length +
                      widget.reblogsList.length,
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
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (final BuildContext ctx, final int index) {
                        return ReplyTile(
                          commentText: widget.repliesList[index]["reply_text"],
                          userName: widget.repliesList[index]["blog_username"],
                          avatarUrl: widget.repliesList[index]["blog_avatar"],
                          avatarShape: widget.repliesList[index]["blog_avatar_shape"],
                        );
                      },
                      itemCount: widget.repliesList.length,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextField(
                          controller: replyController,
                          decoration: const InputDecoration(
                            hintText: "Unleash a compliment...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "Reply",
                            style: TextStyle(
                              color: (replyController.text.isNotEmpty)
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    title: FittedBox(
                      child: (blogTypeToShow == blogsType.withComments)
                          ? const Text(
                              "Reblogs with comments",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 17),
                            )
                          : const Text(
                              "Other reblogs",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 17),
                            ),
                    ),
                    floating: true,
                    backgroundColor: Colors.white,
                    titleSpacing: 0,
                    elevation: 1,
                    forceElevated: true,
                    expandedHeight: 2,
                    toolbarHeight: 40,
                    leadingWidth: 10,
                    leading: Container(),
                    actions: [
                      IconButton(
                        onPressed: () {
                          showEditPostBottomSheet(
                              context, blogTypeToShow, changeBlogViewSection);
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                      )
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => (blogTypeToShow ==
                              blogsType.withComments)
                          ? ReblogTileWithComments(
                              avatarUrl: widget.reblogsWithCommentsList[index]
                                  ["blog_avatar"],
                              htmlData: widget.reblogsWithCommentsList[index]
                                  ["reblog_content"],
                              userName: widget.reblogsWithCommentsList[index]
                                  ["blog_username"],
                                  avatarShape: widget.reblogsWithCommentsList[index]
                                  ["blog_avatar_shape"] ,
                            )
                          : ReblogTileWithOutComments(
                              userName: widget.reblogsWithOutCommentsList[index]
                                  ["blog_username"],
                              avatartUrl:
                                  widget.reblogsWithOutCommentsList[index]
                                      ["blog_avatar"],
                                      avatarShape: widget.reblogsWithOutCommentsList[index]
                                      ["blog_avatar_shape"] ,
                            ),
                      childCount: (blogTypeToShow == blogsType.withComments)
                          ? widget.reblogsWithCommentsList.length
                          : widget.reblogsWithOutCommentsList.length,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: (final BuildContext ctx, final int index) {
                  return LikeTile(
                    blogAvatar: widget.likesList[index]["blog_avatar"],
                    blogTitle: widget.likesList[index]["blog_title"],
                    followStatus: widget.likesList[index]["followed"],
                    userName: widget.likesList[index]["blog_username"],
                    avatarShape: widget.likesList[index]["blog_avatar_shape"],
                  );
                },
                itemCount: widget.likesList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReblogTileWithOutComments extends StatelessWidget {
  const ReblogTileWithOutComments(
      {required final this.avatartUrl,
      required final this.userName,
      required this.avatarShape,
      Key? key})
      : super(key: key);

  final avatartUrl;
  final userName;
  final avatarShape;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Row(
            children: [
              PersonAvatar(avatarPhotoLink: avatartUrl, shape: avatarShape),
              SizedBox(
                width: 1,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  userName,
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReblogTileWithComments extends StatelessWidget {
  const ReblogTileWithComments(
      {required final this.avatarUrl,
      required final this.userName,
      required final this.htmlData,
      required final this.avatarShape,
      Key? key})
      : super(key: key);

  final String avatarUrl;
  final String userName;
  final String htmlData;
  final String avatarShape;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                PersonAvatar(avatarPhotoLink: avatarUrl, shape: avatarShape),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    userName,
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                  ),
                ))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: HtmlView(htmlData: htmlData),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Reblog",
                    style: TextStyle(color: Colors.black54, fontSize: 17),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View Post",
                    style: TextStyle(color: Colors.black54, fontSize: 17),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

class LikeTile extends StatelessWidget {
  ///
  const LikeTile({
    required final this.userName,
    required final this.blogTitle,
    required final this.blogAvatar,
    required final this.followStatus,
    required final this.avatarShape,
    final Key? key,
  }) : super(key: key);

  final String userName;
  final String blogTitle;
  final String blogAvatar;
  final bool followStatus;
  final String avatarShape;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PersonAvatar(avatarPhotoLink: blogAvatar, shape: avatarShape),
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
    required final this.avatarUrl,
    required final this.userName,
    required final this.commentText,
    required final this.avatarShape,
    final Key? key,
  }) : super(key: key);

  ///
  final String avatarUrl;

  ///
  final String userName;

  ///
  final String commentText;

  ///
  final String avatarShape;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         PersonAvatar(avatarPhotoLink: avatarUrl, shape: avatarShape),
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
