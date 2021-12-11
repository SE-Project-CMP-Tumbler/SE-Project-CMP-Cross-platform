// ignore_for_file: must_be_immutable, lines_longer_than_80_chars

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:tumbler/Widgets/Exceptions_UI/empty_list_exception.dart";
import "package:tumbler/Widgets/Notes/Tiles/like_tile.dart";
import "package:tumbler/Widgets/Notes/Tiles/reblog_tile_with_comments.dart";
import "package:tumbler/Widgets/Notes/Tiles/rebolg_tile_without_comments.dart";
import "package:tumbler/Widgets/Notes/Tiles/reply_tile.dart";
import "package:tumbler/Widgets/Notes/customized_tab.dart";
import "package:tumbler/Widgets/Notes/show_reblog_type_bottom_sheet.dart";

/// [blogType] is an Enumerator for specifing two different reblogs types
enum blogsType {
  ///reblogs with comments
  withComments,

  ///reblogs without comments
  others
}

/// [Notes] is a class handels all stuff related to notes
class Notes extends StatefulWidget {
  /// Takes likeList, reblogList and repliesList
  Notes({
    required final this.likesList,
    required final this.reblogsList,
    required final this.repliesList,
    final Key? key,
  }) : super(key: key);

  /// contains all likes with their detalis
  List<dynamic> likesList = <dynamic>[];

  ///contains all reblogs with their detalis
  List<dynamic> reblogsList = <dynamic>[];

  /// contains all reblogs with comments with their detalis
  List<dynamic> reblogsWithCommentsList = <dynamic>[];

  ///contains all likes without comments their detalis
  List<dynamic> reblogsWithOutCommentsList = <dynamic>[];

  /// contains all replies with their detalis
  List<dynamic> repliesList = <dynamic>[];

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> with SingleTickerProviderStateMixin {
  late TabController tabController;

  //
  final TextEditingController replyController = TextEditingController();

  int blogTypeToShow = blogsType.withComments.index;

  void checkReplyText() {
    setState(() {});
  }

  void changeBlogViewSection(final Enum type) {
    setState(() {
      blogTypeToShow = type.index;
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
          titleSpacing: 30,
          title: Row(
            children: <Widget>[
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
            if (widget.repliesList.isEmpty)
              const EmptyBoxImage(msg: "No replies to show")
            else
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (final BuildContext ctx, final int index) {
                          return ReplyTile(
                            commentText: widget.repliesList[index]
                                ["reply_text"],
                            userName: widget.repliesList[index]
                                ["blog_username"],
                            avatarUrl: widget.repliesList[index]["blog_avatar"],
                            avatarShape: widget.repliesList[index]
                                ["blog_avatar_shape"],
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
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            if (widget.reblogsWithCommentsList.isEmpty &&
                    blogTypeToShow == blogsType.withComments.index ||
                widget.reblogsWithOutCommentsList.isEmpty &&
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
                                    avatarUrl:
                                        widget.reblogsWithCommentsList[index]
                                            ["blog_avatar"],
                                    htmlData:
                                        widget.reblogsWithCommentsList[index]
                                            ["reblog_content"],
                                    userName:
                                        widget.reblogsWithCommentsList[index]
                                            ["blog_username"],
                                    avatarShape:
                                        widget.reblogsWithCommentsList[index]
                                            ["blog_avatar_shape"],
                                  )
                                : ReblogTileWithOutComments(
                                    userName:
                                        widget.reblogsWithOutCommentsList[index]
                                            ["blog_username"],
                                    avatartUrl:
                                        widget.reblogsWithOutCommentsList[index]
                                            ["blog_avatar"],
                                    avatarShape:
                                        widget.reblogsWithOutCommentsList[index]
                                            ["blog_avatar_shape"],
                                  ),
                        childCount:
                            (blogTypeToShow == blogsType.withComments.index)
                                ? widget.reblogsWithCommentsList.length
                                : widget.reblogsWithOutCommentsList.length,
                      ),
                    )
                  ],
                ),
              ),
            if (widget.likesList.isEmpty)
              const EmptyBoxImage(msg: "No likes to show")
            else
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
