// ignore_for_file: must_be_immutable, lines_longer_than_80_chars
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Widgets/Exceptions_UI/empty_list_exception.dart";
import "package:tumbler/Widgets/Notes/Tiles/like_tile.dart";
import "package:tumbler/Widgets/Notes/Tiles/reblog_tile_with_comments.dart";
import "package:tumbler/Widgets/Notes/Tiles/reblog_tile_without_comments.dart";
import "package:tumbler/Widgets/Notes/Tiles/reply_tile.dart";
import "package:tumbler/Widgets/Notes/customized_tab.dart";
import "package:tumbler/Widgets/Notes/reply_text_field.dart";
import "package:tumbler/Widgets/Notes/show_reblog_type_bottom_sheet.dart";

/// [blogType] is an Enumerator for specifying two different reblogs types
enum blogsType {
  ///reblogs with comments
  withComments,

  ///reblogs without comments
  others
}

/// [NotesPage] is a class handles all stuff related to notes
class NotesPage extends StatefulWidget {
  /// Takes likeList, reblogList and repliesList
  NotesPage({
    required final this.postID,
    final Key? key,
  }) : super(key: key);

  /// Post ID
  int postID = 0;

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int likeCount = 0;
  int repliesCount = 0;
  int reblogCount = 0;

  /// contains all likes with their details
  List<dynamic> likesList = <dynamic>[];

  ///contains all reblogs with their details
  List<dynamic> reblogsList = <dynamic>[];

  /// contains all replies with their details
  List<dynamic> repliesList = <dynamic>[];

  /// contains all reblogs with comments with their details
  List<dynamic> reblogsWithCommentsList = <dynamic>[];

  ///contains all likes without comments their details
  List<dynamic> reblogsWithOutCommentsList = <dynamic>[];

  Future<void> initialize() async {
    final Map<String, dynamic> receivedNotes =
    await Api().getNotes(widget.postID.toString());

    reblogsWithOutCommentsList.clear();
    reblogsWithCommentsList.clear();
    likesList.clear();
    reblogsList.clear();
    repliesList.clear();
    setState(() {});
    //check the status code for the received response.
    if (receivedNotes["meta"]["status"] == "200") {
      likeCount =
      receivedNotes["response"]["likes"]["pagination"]["total"] as int;
      repliesCount =
      receivedNotes["response"]["replies"]["pagination"]["total"] as int;
      reblogCount =
      receivedNotes["response"]["reblogs"]["pagination"]["total"] as int;
      likesList = receivedNotes["response"]["likes"]["likes"] ?? <dynamic>[];
      reblogsList =
          receivedNotes["response"]["reblogs"]["reblogs"] ?? <dynamic>[];
      repliesList =
          receivedNotes["response"]["replies"]["replies"] ?? <dynamic>[];

      // spilt blogs received into to sub-categories
      for (int i = 0; i < reblogCount; i++) {
        if (reblogsList[i]["reblog_content"].isEmpty) {
          reblogsWithOutCommentsList.add(reblogsList[i]);
        } else {
          reblogsWithCommentsList.add(reblogsList[i]);
        }
      }
      setState(() {});
    } else
      await showToast(receivedNotes["meta"]["msg"]);
  }

  bool updateFollowStatusLocally(final String blogId, final bool followStatus) {
    bool found = false;

    likesList.map((final dynamic x) {
      if (x["blog_id"].toString() == blogId) {
        found = true;
        x["followed"] = followStatus;
        return x;
      } else
        return x;
    });

    return found;
  }

  //
  final TextEditingController replyController = TextEditingController();

  int blogTypeToShow = blogsType.withComments.index;

  void checkReplyText() {
    setState(() {});
  }

  Future<void> refresh() async {
    likesList.clear();
    reblogsList.clear();
    repliesList.clear();
    reblogsWithCommentsList.clear();
    reblogsWithOutCommentsList.clear();
    await initialize();
    setState(() {});
  }

  void changeBlogViewSection(final Enum type) {
    setState(() {
      blogTypeToShow = type.index;
    });
  }

  @override
  void initState() {
    initialize();
    // Start listening to changes.
    replyController.addListener(checkReplyText);
    tabController = TabController(vsync: this, length: 3);
    super.initState();
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
        number: repliesCount,
        color: Colors.blue,
        currIndex: tabController.index,
        myIndex: 0,
      ),
      CustomizedTab(
        iconType: Icons.repeat,
        number: reblogCount,
        color: Colors.green,
        currIndex: tabController.index,
        myIndex: 1,
      ),
      CustomizedTab(
        iconType: Icons.favorite_outline_outlined,
        number: likeCount,
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
          titleSpacing: 30,
          title: Row(
            children: <Widget>[
              Text(
                "${numFormatter.format(
                  likeCount + repliesCount + reblogCount,
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
            if (repliesList.isEmpty)
              Column(
                children: <Widget>[
                  const Spacer(),
                  if (MediaQuery.of(context).viewInsets.bottom < 10)
                    const EmptyBoxImage(msg: "No replies to show"),
                  const Spacer(),
                  ReplyTextField(
                    replyController: replyController,
                    postId: widget.postID.toString(),
                    refresh: refresh,
                  )
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (final BuildContext ctx, final int index) {
                          return ReplyTile(
                            commentText: repliesList[index]["reply_text"],
                            userName: repliesList[index]["blog_username"],
                            avatarUrl: repliesList[index]["blog_avatar"],
                            avatarShape: repliesList[index]
                            ["blog_avatar_shape"],
                            blogID: repliesList[index]["blog_id"].toString(),
                          );
                        },
                        itemCount: repliesList.length,
                      ),
                    ),
                    ReplyTextField(
                      replyController: replyController,
                      postId: widget.postID.toString(),
                      refresh: refresh,
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
                      child: (blogTypeToShow == blogsType.withComments.index)
                          ? const Text(
                        "Reblogs with comments",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 17,
                        ),
                      )
                          : const Text(
                        "Other reblogs",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 17,
                        ),
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
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {
                          showReblogsCategoriesBottomSheet(
                            context,
                            blogTypeToShow,
                            changeBlogViewSection,
                          );
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
                          (final BuildContext context, final int index) =>
                      (reblogsWithCommentsList.isEmpty &&
                          blogTypeToShow ==
                              blogsType.withComments.index ||
                          reblogsWithOutCommentsList.isEmpty &&
                              blogTypeToShow == blogsType.others.index)
                          ? Column(
                        children: const <Widget>[
                          SizedBox(
                            height: 90,
                          ),
                          EmptyBoxImage(
                            msg: "No reblogs to show",
                          ),
                        ],
                      )
                          : (blogTypeToShow == blogsType.withComments.index)
                          ? ReblogTileWithComments(
                        avatarUrl: reblogsWithCommentsList[index]
                        ["blog_avatar"],
                        htmlData: reblogsWithCommentsList[index]
                        ["reblog_content"],
                        userName: reblogsWithCommentsList[index]
                        ["blog_username"],
                        avatarShape:
                        reblogsWithCommentsList[index]
                        ["blog_avatar_shape"],
                        blogID: reblogsWithCommentsList[index]
                        ["blog_id"]
                            .toString(),
                      )
                          : ReblogTileWithOutComments(
                        userName:
                        reblogsWithOutCommentsList[index]
                        ["blog_username"],
                        avatarUrl:
                        reblogsWithOutCommentsList[index]
                        ["blog_avatar"],
                        avatarShape:
                        reblogsWithOutCommentsList[index]
                        ["blog_avatar_shape"],
                        blogID: reblogsWithOutCommentsList[index]
                        ["blog_id"]
                            .toString(),
                      ),
                      childCount: (reblogsWithCommentsList.isEmpty &&
                          blogTypeToShow ==
                              blogsType.withComments.index ||
                          reblogsWithOutCommentsList.isEmpty &&
                              blogTypeToShow == blogsType.others.index)
                          ? 1
                          : (blogTypeToShow == blogsType.withComments.index)
                          ? reblogsWithCommentsList.length
                          : reblogsWithOutCommentsList.length,
                    ),
                  )
                ],
              ),
            ),
            if (likesList.isEmpty)
              const EmptyBoxImage(msg: "No likes to show")
            else
              Padding(
                padding: const EdgeInsets.all(5),
                child: ListView.builder(
                  itemBuilder: (final BuildContext ctx, final int index) {
                    return LikeTile(
                      blogAvatar: likesList[index]["blog_avatar"],
                      blogTitle: likesList[index]["blog_title"],
                      followStatus: likesList[index]["followed"],
                      userName: likesList[index]["blog_username"],
                      avatarShape: likesList[index]["blog_avatar_shape"],
                      blogID: likesList[index]["blog_id"].toString(),
                      updateFollowStatusLocally: updateFollowStatusLocally,
                    );
                  },
                  itemCount: likesList.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}