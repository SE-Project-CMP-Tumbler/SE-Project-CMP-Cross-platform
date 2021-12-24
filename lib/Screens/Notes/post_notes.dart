// ignore_for_file: must_be_immutable, lines_longer_than_80_chars

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import "package:tumbler/Widgets/Exceptions_UI/empty_list_exception.dart";
import "package:tumbler/Widgets/Notes/Tiles/like_tile.dart";
import "package:tumbler/Widgets/Notes/Tiles/reblog_tile_with_comments.dart";
import "package:tumbler/Widgets/Notes/Tiles/rebolg_tile_without_comments.dart";
import "package:tumbler/Widgets/Notes/Tiles/reply_tile.dart";
import "package:tumbler/Widgets/Notes/customized_tab.dart";
import "package:tumbler/Widgets/Notes/reply_textfield.dart";
import "package:tumbler/Widgets/Notes/show_reblog_type_bottom_sheet.dart";

/// [blogType] is an Enumerator for specifing two different reblogs types
enum blogsType {
  ///reblogs with comments
  withComments,

  ///reblogs without comments
  others
}

/// [NotesPage] is a class handels all stuff related to notes
class NotesPage extends StatefulWidget {
  /// Takes likeList, reblogList and repliesList
  NotesPage({
    required final this.postID,
    required final this.index,
    final Key? key,
  }) : super(key: key);

  /// Post ID
  int postID;

  /// Post Index
  int index;

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  /// contains all likes with their details
  List<dynamic> likesList = <dynamic>[];

  ///contains all reblogs with their detalis
  List<dynamic> reblogsList = <dynamic>[];

  /// contains all replies with their details
  List<dynamic> repliesList = <dynamic>[];

  /// contains all reblogs with comments with their detalis
  List<dynamic> reblogsWithCommentsList = <dynamic>[];

  ///contains all likes without comments their detalis
  List<dynamic> reblogsWithOutCommentsList = <dynamic>[];

  Future<void> initialize() async {
    final Map<String, dynamic> recievedNotes =
        await Api().getNotes(widget.postID.toString());

    //check the status code for the received response.
    if (recievedNotes["meta"]["status"] == "404")
      throw HttpException("Not Found!");
    else {
      likesList = recievedNotes["response"]["likes"] ?? <dynamic>[];
      reblogsList = recievedNotes["response"]["reblogs"] ?? <dynamic>[];
      repliesList = recievedNotes["response"]["replies"] ?? <dynamic>[];

      // spilt blogs received into to sub-categories
      for (int i = 0; i < reblogsList.length; i++) {
        if (reblogsList[i]["reblog_content"].isEmpty) {
          reblogsWithOutCommentsList.add(reblogsList[i]);
        } else {
          reblogsWithCommentsList.add(reblogsList[i]);
        }
      }
    }
  }

  //
  final TextEditingController replyController = TextEditingController();

  int blogTypeToShow = blogsType.withComments.index;

  void checkReplyText() {
    setState(() {});
  }

  Future<void> refresh() async {
    setState(() async {
      await initialize();
    });
  }

  void changeBlogViewSection(final Enum type) {
    setState(() {
      blogTypeToShow = type.index;
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
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
            number: repliesList.length,
            color: Colors.blue,
            currIndex: tabController.index,
            myIndex: 0,
          ),
          CustomizedTab(
            iconType: Icons.repeat,
            number: reblogsList.length,
            color: Colors.green,
            currIndex: tabController.index,
            myIndex: 1,
          ),
          CustomizedTab(
            iconType: Icons.favorite_outline_outlined,
            number: likesList.length,
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
                  likesList.length + repliesList.length + reblogsList.length,
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
                children: [
                  const Spacer(),
                  if (MediaQuery.of(context).viewInsets.bottom < 10)
                    const EmptyBoxImage(msg: "No replies to show"),
                  const Spacer(),
                  ReplyTextField(
                    replyController: replyController,
                    postId: widget.postID.toString(),
                    refresh: refresh,
                    index: widget.index,
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
                      index: widget.index,
                    ),
                  ],
                ),
              ),
            if (reblogsWithCommentsList.isEmpty &&
                    blogTypeToShow == blogsType.withComments.index ||
                reblogsWithOutCommentsList.isEmpty &&
                    blogTypeToShow == blogsType.others.index)
              const EmptyBoxImage(msg: "No reblogs to show")
            else
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
                            (blogTypeToShow == blogsType.withComments.index)
                                ? ReblogTileWithComments(
                                    avatarUrl: reblogsWithCommentsList[index]
                                        ["blog_avatar"],
                                    htmlData: reblogsWithCommentsList[index]
                                        ["reblog_content"],
                                    userName: reblogsWithCommentsList[index]
                                        ["blog_username"],
                                    avatarShape: reblogsWithCommentsList[index]
                                        ["blog_avatar_shape"],
                                    blogID: reblogsWithCommentsList[index]
                                            ["blog_id"]
                                        .toString(),
                                  )
                                : ReblogTileWithOutComments(
                                    userName: reblogsWithOutCommentsList[index]
                                        ["blog_username"],
                                    avatarUrl: reblogsWithOutCommentsList[index]
                                        ["blog_avatar"],
                                    avatarShape:
                                        reblogsWithOutCommentsList[index]
                                            ["blog_avatar_shape"],
                                    blogID: reblogsWithOutCommentsList[index]
                                            ["blog_id"]
                                        .toString(),
                                  ),
                        childCount:
                            (blogTypeToShow == blogsType.withComments.index)
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
