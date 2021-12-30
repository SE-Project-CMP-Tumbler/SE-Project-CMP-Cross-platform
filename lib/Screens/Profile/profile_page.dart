// ignore_for_file: lines_longer_than_80_chars
import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:image_picker/image_picker.dart";
import "package:share_plus/share_plus.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/choose_image.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/blog_theme.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Add_Post/add_new_post.dart";
import 'package:tumbler/Screens/Chat/inside_chat.dart';
import "package:tumbler/Screens/Profile/create_new_blog.dart";
import "package:tumbler/Screens/Profile/profile_search.dart";
import "package:tumbler/Screens/Search/search_page.dart";
import "package:tumbler/Screens/Settings/profile_settings.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

/// Profile Page of the User
class ProfilePage extends StatefulWidget {
  /// constructor
  const ProfilePage({
    required final this.blogID,
    final Key? key,
  }) : super(key: key);

  /// takes the current blog index
  final String blogID;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  TabController? tabController;
  Color themeColor = const Color(0xff001935);
  Color themeTitleColor = const Color(0xffffffff);
  Color accentColor = const Color(0xffffffff);
  late AnimationController loadingSpinnerAnimationController;

  /// Bool to indicate if the Blog is mine
  bool _isMine = false;

  /// Used if the blog is mine
  List<Blog> blogs = <Blog>[];

  /// Data of the Displayed Blog
  Blog displayedBlog = Blog(
    blogId: "",
    isPrimary: false,
    username: "",
    avatarImageUrl:
        "https://cdnb.artstation.com/p/assets/images/images/033/268/113/large/edmerc-d-mercadal-eren-v5.jpg?1609001111",
    avatarShape: "",
    headerImage:
        "https://cdna.artstation.com/p/assets/images/images/011/360/222/large/moraya-magdy-maro-45-1.jpg?1529180970",
    blogTitle: "",
    allowAsk: false,
    allowSubmission: false,
    blogDescription: "",
  );
  BlogTheme theme = BlogTheme(
    themeID: "",
    titleText: "Untitled",
    titleColor: "FFFFFF",
    titleFont: "",
    titleWeight: "",
    description: "",
    backgroundColor: "FFFFFF",
    accentColor: "FFFFFF",
    bodyFont: "",
    headerImage: "",
    avatarURL: "",
    avatarShape: "circle",
  );

  final List<String> _tabs = <String>["Posts"];

  final List<String> _messageOptions = <String>["Send a message"];
  final List<String> _personIconOptions = <String>[
    "Share",
    "Get Notifications",
    "Block",
    "Report"
  ];

  final List<String> blogUserNames =
      User.blogsNames + <String>["Create new tumblr"];
  String dropdownValue = User.blogsNames[User.currentProfile];

  Widget? myBlogsDropDown;

  /// current opened tab
  late String currentTab;

  /// true when posts are loading.
  bool _isLoading = false;

  /// Indicate that more posts are fetched
  bool _gettingPosts = false;

  /// list of current profile posts.
  List<PostModel> postsTabPosts = <PostModel>[];

  /// for Pagination Post Tab
  int currentPagePosts = 0;

  /// list of current posts liked.
  List<PostModel> postsTabLiked = <PostModel>[];

  /// for Pagination Likes Tab
  int currentPageLiked = 0;

  /// list of Following Users.
  /// Type is [followListTile]
  List<Map<String, dynamic>> followingTabList = <Map<String, dynamic>>[];

  /// for Pagination Likes Tab
  int currentPageFollowing = 0;

  final ScrollController _controller = ScrollController();

  Future<void> fetchProfilePosts() async {
    setState(() => _isLoading = true);
    postsTabPosts.clear();
    currentPagePosts = 0;
    final Map<String, dynamic> response =
        await Api().fetchSpecificBlogPost(widget.blogID, currentPagePosts + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["posts"] as List<dynamic>).isNotEmpty) {
        currentPagePosts++;
        postsTabPosts.addAll(
          await PostModel.fromJSON(response["response"]["posts"]),
        );
      }
    } else {
      await showToast(response["meta"]["msg"]);
    }
    setState(() => _isLoading = false);
  }

  Future<void> getMoreProfilePosts() async {
    if (_gettingPosts) {
      return;
    }
    _gettingPosts = true;
    final Map<String, dynamic> response =
        await Api().fetchSpecificBlogPost(widget.blogID, currentPagePosts + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["posts"] as List<dynamic>).isNotEmpty) {
        currentPagePosts++;
        setState(
          () async => postsTabPosts.addAll(
            await PostModel.fromJSON(response["response"]["posts"]),
          ),
        );
      }
    } else
      await showToast(response["meta"]["msg"]);
    _gettingPosts = false;
  }

  Future<void> fetchLikedPosts() async {
    setState(() => _isLoading = true);
    postsTabLiked.clear();
    currentPageLiked = 0;
    final Map<String, dynamic> response =
        await Api().fetchLikedPost(displayedBlog.blogId!, currentPageLiked + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["posts"] as List<dynamic>).isNotEmpty) {
        currentPageLiked++;
        postsTabLiked.addAll(
          await PostModel.fromJSON(response["response"]["posts"]),
        );
      }
    } else {
      await showToast(response["meta"]["msg"]);
    }
    setState(() => _isLoading = false);
  }

  Future<void> getMoreLikedPosts() async {
    if (_gettingPosts) {
      return;
    }
    _gettingPosts = true;
    final Map<String, dynamic> response =
        await Api().fetchLikedPost(displayedBlog.blogId!, currentPageLiked + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["posts"] as List<dynamic>).isNotEmpty) {
        currentPageLiked++;
        setState(
          () async => postsTabLiked.addAll(
            await PostModel.fromJSON(response["response"]["posts"]),
          ),
        );
      }
    } else
      await showToast(response["meta"]["msg"]);
    _gettingPosts = false;
  }

  Future<void> fetchFollowing() async {
    setState(() => _isLoading = true);
    followingTabList.clear();
    currentPageFollowing = 0;
    final Map<String, dynamic> response = await Api()
        .fetchFollowings(displayedBlog.blogId!, currentPageFollowing + 1);

    if (response["meta"]["status"] == "200") {
      final List<dynamic> x =
          response["response"]["followings"] as List<dynamic>;
      if (x.isNotEmpty) {
        currentPageFollowing++;

        for (final dynamic element in x) {
          followingTabList.add(element);
        }

        setState(() {}); // to update the list
      }
    } else {
      await showToast(response["meta"]["msg"]);
    }
    setState(() => _isLoading = false);
  }

  Future<void> getMoreFollowing() async {
    if (_gettingPosts) {
      return;
    }
    _gettingPosts = true;
    final Map<String, dynamic> response = await Api()
        .fetchFollowings(displayedBlog.blogId!, currentPageFollowing + 1);

    if (response["meta"]["status"] == "200") {
      final List<dynamic> x =
          response["response"]["followings"] as List<dynamic>;
      if (x.isNotEmpty) {
        currentPageFollowing++;
        for (final dynamic element in x) {
          followingTabList.add(element);
        }

        setState(() {}); // to update the list
      }
    } else
      await showToast(response["meta"]["msg"]);
    _gettingPosts = false;
  }

  Widget followListTile(
    final int index,
  ) {
    // followListTile(
    //   follow["blog_avatar"],
    //   follow["blog_avatar_shape"],
    //   follow["blog_username"],
    //   follow["title"] ?? "Untitled",
    //   follow["blog_id"] as int,
    //   follow["is_followed"] as bool,
    // ),
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<ProfilePage>(
                builder: (final BuildContext context) => ProfilePage(
                  blogID: followingTabList[index]["blog_id"].toString(),
                ),
              ),
            );
          },
          dense: true,
          leading: PersonAvatar(
            avatarPhotoLink: followingTabList[index]["blog_avatar"],
            shape: followingTabList[index]["blog_avatar_shape"],
            blogID: followingTabList[index]["blog_id"].toString(),
          ),
          title: Text(followingTabList[index]["blog_username"]),
          subtitle: Text(followingTabList[index]["title"] ?? "Untitled"),
          trailing: TextButton(
            onPressed: () async {
              Map<String, dynamic> response = <String, dynamic>{};
              if (followingTabList[index]["is_followed"] as bool)
                response = await Api()
                    .unFollowBlog(followingTabList[index]["blog_id"]);
              else
                response =
                    await Api().followBlog(followingTabList[index]["blog_id"]);

              if (response["meta"]["status"] == "200")
                setState(
                  () => followingTabList[index]["is_followed"] =
                      !followingTabList[index]["is_followed"],
                );
              else
                await showToast(response["meta"]["msg"]);
            },
            child: followingTabList[index]["is_followed"] as bool
                ? const Text(
                    "Unfollow",
                    style: TextStyle(color: Colors.red),
                  )
                : const Text(
                    "Follow",
                    style: TextStyle(color: Colors.blue),
                  ),
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget postsTab(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchProfilePosts,
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
          : postsTabPosts.isEmpty
              ? _isMine
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "This is your Tumbler, and you",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            "can fill it with whatever you want.",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<AddPost>(
                                  builder: (final BuildContext context) =>
                                      AddPost(),
                                ),
                              );
                            },
                            child: const Text(
                              "Make a post",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text(
                        "This Tumbler has no posts",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
              : CustomScrollView(
                  // The "controller" and "primary" members should be left
                  // unset, so that the NestedScrollView can control this
                  // inner scroll view.
                  // If the "controller" property is set, then this scroll
                  // view will not be associated with the NestedScrollView.
                  // The PageStorageKey should be unique to this ScrollView;
                  // it allows the list to remember its scroll position when
                  // the tab view is not on the screen.
                  key: PageStorageKey<String>(_tabs[0]),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 18),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (
                            final BuildContext context,
                            final int index,
                          ) {
                            // This builder is called for each child.
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 18,
                              ),
                              child: PostOutView(
                                post: postsTabPosts[index],
                                index: 0, // dump
                              ),
                            );
                          },
                          // The childCount of the SliverChildBuilderDelegate
                          // specifies how many children this inner list
                          // has.
                          childCount: postsTabPosts.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget likesTab(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchLikedPosts,
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
          : postsTabLiked.isEmpty
              ? _isMine
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Aw. You don't like anything",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<SearchPage>(
                                  builder: (final BuildContext context) =>
                                      const SearchPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Find something to like",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Aw. This Tumbler don't like anything",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<SearchPage>(
                                  builder: (final BuildContext context) =>
                                      const SearchPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Find something to like",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    )
              : CustomScrollView(
                  // The "controller" and "primary" members should be left
                  // unset, so that the NestedScrollView can control this
                  // inner scroll view.
                  // If the "controller" property is set, then this scroll
                  // view will not be associated with the NestedScrollView.
                  // The PageStorageKey should be unique to this ScrollView;
                  // it allows the list to remember its scroll position when
                  // the tab view is not on the screen.
                  key: PageStorageKey<String>(_tabs[1]),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 18),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (
                            final BuildContext context,
                            final int index,
                          ) {
                            // This builder is called for each child.
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 18,
                              ),
                              child: PostOutView(
                                post: postsTabLiked[index],
                                index: index, // dump , not used in this case
                              ),
                            );
                          },
                          // The childCount of the SliverChildBuilderDelegate
                          // specifies how many children this inner list
                          // has.
                          childCount: postsTabLiked.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget followingTab(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchFollowing,
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
          : followingTabList.isEmpty
              ? _isMine
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Aw. You don't follow anyone",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<SearchPage>(
                                  builder: (final BuildContext context) =>
                                      const SearchPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Find something to follow",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Aw. This Tumbler don't follow anyone",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<SearchPage>(
                                  builder: (final BuildContext context) =>
                                      const SearchPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Find something to follow",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    )
              : CustomScrollView(
                  // The "controller" and "primary" members should be left
                  // unset, so that the NestedScrollView can control this
                  // inner scroll view.
                  // If the "controller" property is set, then this scroll
                  // view will not be associated with the NestedScrollView.
                  // The PageStorageKey should be unique to this ScrollView;
                  // it allows the list to remember its scroll position when
                  // the tab view is not on the screen.
                  key: PageStorageKey<String>(_tabs[2]),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 18),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (
                            final BuildContext context,
                            final int index,
                          ) {
                            // This builder is called for each child.
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 18,
                              ),
                              child: followListTile(index),
                            );
                          },
                          // The childCount of the SliverChildBuilderDelegate
                          // specifies how many children this inner list
                          // has.
                          childCount: followingTabList.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  void showMessagesOption() {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(
        25,
        25,
        0,
        0,
      ),
      //position where you want to show the menu on screen
      items: _messageOptions
          .map(
            (final String e) => PopupMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      elevation: 8,
    ).then((final String? itemSelected) async {
      if (itemSelected == _messageOptions[0]) {
        await Navigator.of(context).push(
          MaterialPageRoute<ChatScreen>(
            builder: (final BuildContext context) => ChatScreen(
              withBlogID: displayedBlog.blogId!,
            ),
          ),
        );
      } else if (itemSelected == _messageOptions[1]) {
        // TODO(Ziyad): Ask
      } else if (itemSelected == _messageOptions[2]) {
        // TODO(Ziyad): Submit a Post
      }
    });
  }

  void showProfileIconOption() {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(
        25,
        25,
        0,
        0,
      ),
      //position where you want to show the menu on screen
      items: _personIconOptions
          .map(
            (final String e) => PopupMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      elevation: 8,
    ).then((final String? itemSelected) async {
      if (itemSelected == "Share") {
        await shareProfile();
      } else if (itemSelected == "Get Notifications") {
      } else if (itemSelected == "Block") {
      } else if (itemSelected == "Report") {
      } else if (itemSelected == "Unfollow") {
        final Map<String, dynamic> response =
            await Api().unFollowBlog(int.parse(widget.blogID));
        if (response["meta"]["status"] == "200")
          await showToast("Unfollowed");
        else
          await showToast(response["meta"]["msg"]);
      } else if (itemSelected == "Follow") {
        final Map<String, dynamic> response =
            await Api().followBlog(int.parse(widget.blogID));
        if (response["meta"]["status"] == "200")
          await showToast("Unfollowed");
        else
          await showToast(response["meta"]["msg"]);
      }
    });
  }

  void showEditAppearance() {
    // index = 0 => change themeColor
    // index = 1 => change accentColor
    // index = 2 => change themeTitleColor
    int _index = 0;
    // color = false  =>  change title and description
    // color = true   =>  change colors
    bool color = true;
    final TextEditingController _titleController =
        TextEditingController(text: displayedBlog.blogTitle);
    final TextEditingController _descriptionController =
        TextEditingController(text: displayedBlog.blogDescription);

    showModalBottomSheet<void>(
      isDismissible: false,
      constraints: const BoxConstraints(minHeight: 500),
      barrierColor: Colors.transparent,
      context: context,
      builder: (final BuildContext context) {
        return StatefulBuilder(
          builder: (final BuildContext context, final StateSetter myState) {
            return WillPopScope(
              onWillPop: () async {
                await Api().setBlogTheme(widget.blogID, theme);
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              color ? Colors.blue : Colors.black,
                            ),
                          ),
                          onPressed: () => myState(() => color = true),
                          child: const Text("Colors"),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              color ? Colors.black : Colors.blue,
                            ),
                          ),
                          onPressed: () => myState(() => color = false),
                          child: const Text("Text"),
                        )
                      ],
                    ),
                    AnimatedCrossFade(
                      crossFadeState: color
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(seconds: 1),
                      firstChild: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    _index == 0 ? Colors.blue : Colors.black,
                                  ),
                                ),
                                onPressed: () => myState(() => _index = 0),
                                child: const Text("BackGround Color"),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    _index == 1 ? Colors.blue : Colors.black,
                                  ),
                                ),
                                onPressed: () => myState(() => _index = 1),
                                child: const Text("Accent Color"),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    _index == 2 ? Colors.blue : Colors.black,
                                  ),
                                ),
                                onPressed: () => myState(() => _index = 2),
                                child: const Text("Title Color"),
                              ),
                            ],
                          ),
                          ColorPicker(
                            enableAlpha: false,
                            paletteType: PaletteType.hsv,
                            pickerColor: themeColor,
                            onColorChanged: (final Color colorPicked) {
                              setState(() {
                                if (_index == 0) {
                                  theme.backgroundColor =
                                      "${colorPicked.red.toRadixString(
                                    16,
                                  )}${colorPicked.green.toRadixString(
                                    16,
                                  )}${colorPicked.blue.toRadixString(
                                    16,
                                  )}";
                                } else if (_index == 1) {
                                  theme.accentColor =
                                      "${colorPicked.red.toRadixString(
                                    16,
                                  )}${colorPicked.green.toRadixString(
                                    16,
                                  )}${colorPicked.blue.toRadixString(
                                    16,
                                  )}";
                                } else {
                                  theme.titleColor =
                                      "${colorPicked.red.toRadixString(
                                    16,
                                  )}${colorPicked.green.toRadixString(
                                    16,
                                  )}${colorPicked.blue.toRadixString(
                                    16,
                                  )}";
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      secondChild: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              controller: _titleController,
                              keyboardType: TextInputType.name,
                              onChanged: (final String s) {
                                setState(() => theme.titleText = s);
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 5,
                                  ),
                                ),
                                label: Text(
                                  "Title",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                hintStyle: TextStyle(color: Colors.white30),
                                hintText: "Title",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              controller: _descriptionController,
                              keyboardType: TextInputType.name,
                              onChanged: (final String s) {
                                setState(() => theme.description = s);
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 5,
                                  ),
                                ),
                                label: Text(
                                  "Description",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                hintStyle: TextStyle(color: Colors.white30),
                                hintText: "Description",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void changeProfilePic() {
    if (User.blogsIDs.contains(displayedBlog.blogId))
      showModalBottomSheet<void>(
        context: context,
        builder: (final BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text(
                  "Change Profile Picture",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ListTile(
                  title: const Text("From Gallery"),
                  onTap: () async {
                    final String? imageData = await chooseImage(
                      ImageSource.gallery,
                    );
                    if (imageData != null) {
                      Map<String, dynamic> response =
                          await Api().uploadImage(imageData);
                      if (response["meta"]["status"] == "200") {
                        final BlogTheme temp = theme;
                        temp.avatarURL = response["response"]["url"].toString();
                        response =
                            await Api().setBlogTheme(widget.blogID, temp);
                        if (response["meta"]["status"] == "200") {
                          setState(() => theme = temp);
                          return;
                        }
                      }
                      await showToast(response["meta"]["msg"]);
                    }
                  },
                ),
                const Divider(
                  height: 15,
                  color: Colors.grey,
                ),
                ListTile(
                  title: const Text("Open Camera"),
                  onTap: () async {
                    final String? imageData = await chooseImage(
                      ImageSource.camera,
                    );
                    if (imageData != null) {
                      Map<String, dynamic> response =
                          await Api().uploadImage(imageData);
                      if (response["meta"]["status"] == "200") {
                        final BlogTheme temp = theme;
                        temp.avatarURL = response["response"]["url"].toString();
                        response =
                            await Api().setBlogTheme(widget.blogID, temp);
                        if (response["meta"]["status"] == "200") {
                          setState(() => theme = temp);
                          return;
                        }
                      }
                      await showToast(response["meta"]["msg"]);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
  }

  void changeHeaderPic() {
    if (User.blogsIDs.contains(displayedBlog.blogId))
      showModalBottomSheet<void>(
        context: context,
        builder: (final BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text(
                  "Change Header Picture",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ListTile(
                  title: const Text("From Gallery"),
                  onTap: () async {
                    final String? imageData = await chooseImage(
                      ImageSource.gallery,
                    );
                    if (imageData != null) {
                      Map<String, dynamic> response =
                          await Api().uploadImage(imageData);
                      if (response["meta"]["status"] == "200") {
                        final BlogTheme temp = theme;
                        temp.headerImage =
                            response["response"]["url"].toString();
                        response =
                            await Api().setBlogTheme(widget.blogID, temp);
                        if (response["meta"]["status"] == "200") {
                          setState(() => theme = temp);
                          return;
                        }
                      }
                      await showToast(response["meta"]["msg"]);
                    }
                  },
                ),
                const Divider(
                  height: 15,
                  color: Colors.grey,
                ),
                ListTile(
                  title: const Text("Open Camera"),
                  onTap: () async {
                    final String? imageData = await chooseImage(
                      ImageSource.camera,
                    );
                    if (imageData != null) {
                      Map<String, dynamic> response =
                          await Api().uploadImage(imageData);
                      if (response["meta"]["status"] == "200") {
                        final BlogTheme temp = theme;
                        temp.headerImage =
                            response["response"]["url"].toString();
                        response =
                            await Api().setBlogTheme(widget.blogID, temp);
                        if (response["meta"]["status"] == "200") {
                          setState(() => theme = temp);
                          return;
                        }
                      }
                      await showToast(response["meta"]["msg"]);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
  }

  void searchIcon() {
    showSearch(
      context: context,
      delegate: ProfileSearch(
        blogID: displayedBlog.blogId!,
        username: displayedBlog.username!,
      ),
    );
  }

  Future<void> initializeBlogData() async {
    // if it is one of my Blogs
    if (User.blogsIDs.contains(widget.blogID)) {
      final int index = User.blogsIDs.indexOf(widget.blogID);

      _isMine = true;
      displayedBlog = Blog(
        blogId: widget.blogID,
        isPrimary: widget.blogID == User.blogsIDs[0],
        username: User.blogsNames[index],
        avatarImageUrl: User.avatars[index],
        avatarShape: User.avatars[index],
        headerImage: User.headerImages[index],
        blogTitle: User.titles[index],
        allowAsk: false,
        // Both 'allowAsk' and 'allowSubmission' won't be used in this case
        allowSubmission: false,
        blogDescription: User.descriptions[index],
      );

      _tabs.addAll(<String>["Likes", "Following"]);
    } else {
      _isMine = false;
      final Map<String, dynamic> response =
          await Api().getBlogInformation(widget.blogID);

      if (response["meta"]["status"] == "200") {
        final Map<String, dynamic> data = response["response"];
        displayedBlog = Blog(
          blogId: widget.blogID,
          isPrimary: false,
          username: data["username"],
          avatarImageUrl: data["avatar"],
          avatarShape: data["avatar_shape"],
          headerImage: data["header_image"],
          blogTitle: data["title"],
          allowAsk: data["allow_ask"],
          allowSubmission: data["allow_submittions"],
          blogDescription: data["description"],
        );
      }

      if ((response["response"]["share_likes"] ?? false) as bool) {
        _tabs.add("Likes");
      }

      if ((response["response"]["share_followings"] ?? false) as bool) {
        _tabs.add("Following");
      }

      if ((response["response"]["followed"] ?? false) as bool) {
        _personIconOptions.add("Unfollow");
      } else {
        _personIconOptions.add("Follow");
      }

      if (displayedBlog.allowAsk!) {
        _messageOptions.add("Ask");
      }

      if (displayedBlog.allowSubmission!) {
        _messageOptions.add("Submit a post");
      }
    }

    setState(() {});
  }

  Future<void> initializeBlogTheme() async {
    final Map<String, dynamic> response =
        await Api().getBlogTheme(widget.blogID);

    if (response["meta"]["status"] == "200") {
      setState(() {
        theme = BlogTheme.fromJSON(response);
      });
    }
  }

  Future<void> shareProfile() async {
    await Share.share(
      "https://tumbler.social/profile/${displayedBlog.username}",
    );
  }

  Widget initializeMyBlogsDropDownMenu() {
    return DropdownButton<String>(
      onChanged: (final String? value) {
        if (value == blogUserNames[blogUserNames.length - 1]) {
          Navigator.push(
            context,
            MaterialPageRoute<CreateNewBlog>(
              builder: (
                final BuildContext context,
              ) =>
                  const CreateNewBlog(),
            ),
          );
        } else {
          setState(() {
            dropdownValue = value!;
            User.currentProfile = User.blogsNames.indexOf(
              value,
            );
            Navigator.of(context).push(
              MaterialPageRoute<ProfilePage>(
                builder: (final BuildContext context) => ProfilePage(
                  blogID: User.blogsIDs[User.currentProfile],
                ),
              ),
            );
          });
        }
      },
      value: dropdownValue,
      // Hide the default underline
      underline: Container(
        height: 0,
      ),
      icon: const Icon(
        Icons.arrow_drop_down_outlined,
        color: Colors.white,
      ),
      isExpanded: true,
      // The list of options
      items: blogUserNames
          .map(
            (final String e) => DropdownMenuItem<String>(
              value: e,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    if (e == blogUserNames[blogUserNames.length - 1])
                      const Icon(
                        Icons.add_circle_outline,
                      )
                    else
                      Image.network(
                        User.avatars[blogUserNames.indexWhere(
                                  (
                                    final String element,
                                  ) =>
                                      element == e,
                                )] ==
                                " "
                            ? "https://picsum.photos/200"
                            : User.avatars[User.currentProfile],
                        width: 35,
                        height: 35,
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),

      // Customize the selected item
      selectedItemBuilder: (
        final BuildContext context,
      ) =>
          blogUserNames
              .map(
                (
                  final String e,
                ) =>
                    Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    myBlogsDropDown = initializeMyBlogsDropDownMenu();
    currentTab = _tabs[0];
    tabController = TabController(length: 3, vsync: this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    _controller.addListener(() async {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 30) {
        if (currentTab == _tabs[0]) {
          await getMoreProfilePosts();
        } else if (currentTab == _tabs[1]) {
          await getMoreLikedPosts();
        } else if (currentTab == _tabs[2]) {
          await getMoreFollowing();
        }
      }
    });

    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();

    initializeBlogTheme();
    initializeBlogData();
    fetchProfilePosts();
  }

  @override
  void dispose() {
    tabController!.dispose();
    SystemChrome.restoreSystemUIOverlays();
    loadingSpinnerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        if (currentTab == _tabs[0]) {
          await fetchProfilePosts();
        } else if (currentTab == _tabs[1]) {
          await fetchLikedPosts();
        } else if (currentTab == _tabs[2]) {
          await fetchFollowing();
        }
      },
      child: DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: Scaffold(
          backgroundColor: Color(
            int.parse(
              "0xff${theme.backgroundColor}",
            ),
          ),
          body: NestedScrollView(
            controller: _controller,
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (final BuildContext context, final bool innerBoxIsScrolled) {
              /// These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                SliverOverlapAbsorber(
                  /// This widget takes the overlapping behavior of the SliverAppBar,
                  /// and redirects it to the SliverOverlapInjector below. If it is
                  /// missing, then it is possible for the nested "inner" scroll view
                  /// below to end up under the SliverAppBar even when the inner
                  /// scroll view thinks it has not been scrolled.
                  /// This is not necessary if the "headerSliverBuilder" only builds
                  /// widgets that do not overlap the next sliver.
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      // All Upper Widgets
                      <Widget>[
                        InkWell(
                          onTap: changeHeaderPic,
                          child: Container(
                            height: 0.35 * _height,
                            // Header image
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FadeInImage(
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (final _, final __, final ___) {
                                    return Image.asset(
                                      "assets/images/profile_Placeholder.png",
                                    );
                                  },
                                  placeholder: const AssetImage(
                                    "assets/images/profile_Placeholder.png",
                                  ),
                                  image: Image.network(
                                    theme.headerImage,
                                  ).image,
                                ).image,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Positioned(
                                  top: 0.35 * _height - 0.085 * _height,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Color(
                                      int.parse(
                                        "0xff${theme.backgroundColor}",
                                      ),
                                    ),
                                    height: 0.8 * _height,
                                  ),
                                ),
                                // Profile Pic
                                Positioned(
                                  bottom: 0.085 * _height - 25,
                                  child: InkWell(
                                    onTap: changeProfilePic,
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Color(
                                          int.parse(
                                            "0xff${theme.backgroundColor}",
                                          ),
                                        ),
                                        shape: theme.avatarShape == "square"
                                            ? BoxShape.rectangle
                                            : BoxShape.circle, //editable
                                        border: Border.all(
                                          width: 3,
                                          color: Color(
                                            int.parse(
                                              "0xff${theme.backgroundColor}",
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            theme.avatarShape == "square"
                                                ? 0
                                                : 50,
                                          ),
                                        ), //editable
                                        child: FadeInImage(
                                          fit: BoxFit.cover,
                                          imageErrorBuilder:
                                              (final _, final __, final ___) {
                                            return Image.asset(
                                              "assets/images/profile_Placeholder.png",
                                            );
                                          },
                                          placeholder: const AssetImage(
                                            "assets/images/profile_Placeholder.png",
                                          ),
                                          image: Image.network(
                                            theme.avatarURL,
                                          ).image,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Title
                                Text(
                                  theme.titleText,
                                  textScaleFactor: 2.4,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(
                                      int.parse(
                                        "0xff${theme.titleColor}",
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: SafeArea(
                                    child: _isMine
                                        ? Row(
                                            children: <Widget>[
                                              // Drop Down Menu of My Blogs
                                              Expanded(
                                                flex: 4,
                                                child: SizedBox(
                                                  width: _width / 2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8,
                                                    ),
                                                    child: myBlogsDropDown,
                                                  ),
                                                ),
                                              ),
                                              // Search Icon
                                              Expanded(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.search_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: searchIcon,
                                                    splashColor: Colors.white10,
                                                  ),
                                                ),
                                              ),
                                              // Appearance Icon
                                              Expanded(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.color_lens,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed:
                                                        showEditAppearance,
                                                    splashColor: Colors.white10,
                                                  ),
                                                ),
                                              ),
                                              // Share Icon
                                              Expanded(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: shareProfile,
                                                    splashColor: Colors.white10,
                                                  ),
                                                ),
                                              ),
                                              // Settings Icon
                                              Expanded(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.settings,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute<
                                                            ProfileSettings>(
                                                          builder: (
                                                            final BuildContext
                                                                context,
                                                          ) =>
                                                              const ProfileSettings(),
                                                        ),
                                                      );
                                                    },
                                                    splashColor: Colors.white10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            // If Showing someone Blog
                                            children: <Widget>[
                                              // Back Icon
                                              Expanded(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.arrow_back_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    splashColor: Colors.white10,
                                                  ),
                                                ),
                                              ),
                                              // User Name
                                              Expanded(
                                                flex: 4,
                                                child: SizedBox(
                                                  width: _width / 2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8,
                                                    ),
                                                    child: Text(
                                                      displayedBlog.blogTitle!,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Search Icon
                                              Expanded(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.search_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: searchIcon,
                                                    splashColor: Colors.white10,
                                                  ),
                                                ),
                                              ),
                                              // Message
                                              Expanded(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.email_rounded,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed:
                                                        showMessagesOption,
                                                    splashColor: Colors.white10,
                                                  ),
                                                ),
                                              ),
                                              // Profile Icon
                                              Expanded(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed:
                                                        showProfileIconOption,
                                                    splashColor: Colors.white10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Description
                        if (theme.description.isNotEmpty)
                          Text(
                            theme.description,
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(
                                int.parse(
                                  "0xff${theme.titleColor}",
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 80,
                    maxHeight: 80,
                    child: Container(
                      color: Color(
                        int.parse(
                          "0xff${theme.backgroundColor}",
                        ),
                      ),
                      child: TabBar(
                        padding: const EdgeInsets.only(top: 32),
                        unselectedLabelColor: Color(
                          int.parse(
                            "0xff${theme.accentColor}",
                          ),
                        ),
                        indicatorColor: Color(
                          int.parse(
                            "0xff${theme.accentColor}",
                          ),
                        ),
                        labelColor: Color(
                          int.parse(
                            "0xff${theme.accentColor}",
                          ),
                        ),
                        onTap: (final int index) async {
                          if (index == 0 && postsTabPosts.isEmpty)
                            await fetchProfilePosts();
                          else if (index == 1 && postsTabLiked.isEmpty)
                            await fetchLikedPosts();
                          else if (index == 2 && followingTabList.isEmpty)
                            await fetchFollowing();
                        },
                        // These are the widgets to put in each tab in the tab bar
                        tabs: _tabs
                            .map(
                              (final String name) => Tab(text: name),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              color: Colors.white,
              child: TabBarView(
                // These are the contents of the tab views, below the tabs.
                children: _tabs
                    .map(
                      (final String name) => Builder(
                        // This Builder is needed to provide a BuildContext that is
                        // "inside" the NestedScrollView, so that
                        // sliverOverlapAbsorberHandleFor() can find the
                        // NestedScrollView.
                        builder: (final BuildContext context) {
                          if (name == _tabs[0]) {
                            currentTab = _tabs[0];
                            return postsTab(context);
                          } else if (name == _tabs[1]) {
                            currentTab = _tabs[1];
                            return likesTab(context);
                          } else if (name == _tabs[2]) {
                            currentTab = _tabs[2];
                            return followingTab(context);
                          } else
                            return Container();
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required final this.minHeight,
    required final this.maxHeight,
    required final this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(final _SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

/// Class to Search in Profile
class ProfileSearch extends SearchDelegate<String> {
  /// Constructor
  ProfileSearch({required this.blogID, required this.username});

  /// Blog ID to Search in
  final String blogID;

  /// UserName
  final String username;

  @override
  List<Widget>? buildActions(final BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<ProfileSearchResult>(
            builder: (final BuildContext context) => ProfileSearchResult(
              word: query,
              blogID: blogID,
              username: username,
            ),
          ),
        ),
        icon: const Icon(Icons.search),
      ),
    ];
  }

  @override
  Widget? buildLeading(final BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.clear),
    );
  }

  @override
  Widget buildResults(final BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(final BuildContext context) {
    return Container();
  }
}
