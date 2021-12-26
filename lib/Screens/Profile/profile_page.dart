// ignore_for_file: lines_longer_than_80_chars
import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Add_Post/add_new_post.dart";
import "package:tumbler/Screens/Profile/create_new_blog.dart";
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
  int themeColor = 0xff001935;
  int themeTitleColor = 0xffffffff;
  int accentColor = 0xffffffff;
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
    avatarImageUrl: "",
    avatarShape: "",
    headerImage: "",
    blogTitle: "",
    allowAsk: false,
    allowSubmission: false,
    blogDescription: "",
  );

  final List<String> _tabs = <String>["Posts"];

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
  List<dynamic> followingTabList = <dynamic>[];

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
          await PostModel.fromJSON(response["response"]["posts"], false),
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
            await PostModel.fromJSON(response["response"]["posts"], false),
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
        await Api().fetchLikedPost(currentPageLiked + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["posts"] as List<dynamic>).isNotEmpty) {
        currentPageLiked++;
        postsTabLiked.addAll(
          await PostModel.fromJSON(response["response"]["posts"], false),
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
        await Api().fetchLikedPost(currentPageLiked + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["posts"] as List<dynamic>).isNotEmpty) {
        currentPageLiked++;
        setState(
          () async => postsTabLiked.addAll(
            await PostModel.fromJSON(response["response"]["posts"], false),
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
    final Map<String, dynamic> response =
        await Api().fetchFollowings(currentPageFollowing + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["followings"] as List<dynamic>).isNotEmpty) {
        currentPageFollowing++;
        for (final Map<String, dynamic> follow in response["response"]
            ["followings"]) {
          followingTabList.add(
            followListTile(
              follow["blog_avatar"],
              follow["blog_avatar_shape"],
              follow["blog_username"],
              follow["title"] ?? "Untitled",
              follow["blog_id"] as int,
            ),
          );
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
    final Map<String, dynamic> response =
        await Api().fetchFollowings(currentPageFollowing + 1);

    if (response["meta"]["status"] == "200") {
      if ((response["response"]["followings"] as List<dynamic>).isNotEmpty) {
        currentPageFollowing++;
        for (final Map<String, dynamic> follow in response["response"]
            ["followings"]) {
          followingTabList.add(
            followListTile(
              follow["blog_avatar"],
              follow["blog_avatar_shape"],
              follow["blog_username"],
              follow["title"] ?? "Untitled",
              follow["blog_id"] as int,
            ),
          );
        }
        setState(() {}); // to update the list
      }
    } else
      await showToast(response["meta"]["msg"]);
    _gettingPosts = false;
  }

  Widget followListTile(
    final String blogAvatar,
    final String blogAvatarShape,
    final String blogUsername,
    final String blogTitle,
    final int blogId,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: () {
            // TODO(Ziyad): go to his profile
            Navigator.of(context).push(
              MaterialPageRoute<ProfilePage>(
                builder: (final BuildContext context) =>
                    ProfilePage(blogID: blogId.toString()),
              ),
            );
          },
          dense: true,
          leading: PersonAvatar(
            avatarPhotoLink: blogAvatar,
            shape: blogAvatarShape,
            blogID: blogId.toString(),
          ),
          title: Text(blogUsername),
          subtitle: Text(blogTitle),
          trailing: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO(Ziyad): implement this
            },
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
                                index: index, // dump
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
                              child: followingTabList[index],
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

  Future<void> initializeBlog() async {
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

      // If it is my main Blog
      if (widget.blogID == User.blogsIDs[0])
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
      /*  UNCOMMENT THIS IF get Likes and Following of other Blog is Working  */
      // response = await Api().getBlogSetting(widget.blogID);
      // if (response["meta"]["status"] == "200") {
      //   if (response["meta"]["share_likes"] != null) {
      //     if (response["meta"]["share_likes"] as bool) {
      //       _tabs.add("Likes");
      //     }
      //   }
      //
      //   if (response["meta"]["share_followings"] != null) {
      //     if (response["meta"]["share_followings"] as bool) {
      //       _tabs.add("Following");
      //     }
      //   }
      // }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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

    initializeBlog();
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
    final List<String> blogUserNames =
        User.blogsNames + <String>["Create new tumblr"];
    String dropdownValue = User.blogsNames[User.currentProfile];
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
          backgroundColor: Color(themeColor),
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
                      <Widget>[
                        // All Upper Widgets
                        Container(
                          height: 0.35 * _height,
                          // Header image
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Image.network(displayedBlog.headerImage!)
                                  .image,
                              fit: BoxFit.cover,
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
                                  color: Color(themeColor),
                                  height: 0.8 * _height,
                                ),
                              ),
                              // Profile Pic
                              Positioned(
                                bottom: 0.085 * _height - 25,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Color(themeColor),
                                    shape: BoxShape.circle, //editable
                                    border: Border.all(
                                      width: 3,
                                      color: Color(themeColor),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        displayedBlog.avatarShape == "square"
                                            ? null
                                            : const BorderRadius.all(
                                                Radius.circular(50),
                                              ), //editable
                                    child: Image.network(
                                      displayedBlog.avatarImageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              // Title
                              Text(
                                displayedBlog.blogTitle!,
                                textScaleFactor: 2.4,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(themeTitleColor),
                                ),
                              ),
                              // Description
                              Text(
                                displayedBlog.blogDescription!,
                                textScaleFactor: 2.4,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(themeTitleColor),
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
                                                  child: DropdownButton<String>(
                                                    onChanged:
                                                        (final String? value) {
                                                      if (value ==
                                                          blogUserNames[
                                                              blogUserNames
                                                                      .length -
                                                                  1]) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute<
                                                              CreateNewBlog>(
                                                            builder: (
                                                              final BuildContext
                                                                  context,
                                                            ) =>
                                                                const CreateNewBlog(),
                                                          ),
                                                        );
                                                      } else {
                                                        setState(() {
                                                          dropdownValue =
                                                              value!;
                                                          User.currentProfile =
                                                              User.blogsNames
                                                                  .indexOf(
                                                            value,
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
                                                      Icons
                                                          .arrow_drop_down_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    isExpanded: true,
                                                    // The list of options
                                                    items: blogUserNames
                                                        .map(
                                                          (final String e) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                            value: e,
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  if (e ==
                                                                      blogUserNames[
                                                                          blogUserNames.length -
                                                                              1])
                                                                    const Icon(
                                                                      Icons
                                                                          .add_circle_outline,
                                                                    )
                                                                  else
                                                                    Image
                                                                        .network(
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
                                                                      height:
                                                                          35,
                                                                    ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      e,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
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
                                                      final BuildContext
                                                          context,
                                                    ) =>
                                                        blogUserNames
                                                            .map(
                                                              (
                                                                final String e,
                                                              ) =>
                                                                  Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                    8,
                                                                  ),
                                                                  child: Text(
                                                                    e,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Search Icon
                                            Expanded(
                                              child: Material(
                                                type: MaterialType.transparency,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.search_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    // TODO(Ziyad): Implement this
                                                  },
                                                  splashColor: Colors.white10,
                                                ),
                                              ),
                                            ),
                                            // Appearance Icon
                                            Expanded(
                                              child: Material(
                                                type: MaterialType.transparency,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.color_lens,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    // TODO(Ziyad): Implement this
                                                  },
                                                  splashColor: Colors.white10,
                                                ),
                                              ),
                                            ),
                                            // Share Icon
                                            Expanded(
                                              child: Material(
                                                type: MaterialType.transparency,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.share,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    // TODO(Ziyad): Implement this
                                                  },
                                                  splashColor: Colors.white10,
                                                ),
                                              ),
                                            ),
                                            // Settings Icon
                                            Expanded(
                                              child: Material(
                                                type: MaterialType.transparency,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.settings,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
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
                                                type: MaterialType.transparency,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_back_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
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
                                                    displayedBlog.username!,
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
                                                type: MaterialType.transparency,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.search_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    // TODO(Ziyad): Implement this
                                                  },
                                                  splashColor: Colors.white10,
                                                ),
                                              ),
                                            ),
                                            // Message
                                            Expanded(
                                              child: Material(
                                                type: MaterialType.transparency,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.email_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    // TODO(Ziyad): Implement this
                                                  },
                                                  splashColor: Colors.white10,
                                                ),
                                              ),
                                            ),
                                            // Profile Icon
                                            Expanded(
                                              child: Material(
                                                type: MaterialType.transparency,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    // TODO(Ziyad): Implement this
                                                  },
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
                      color: Color(themeColor),
                      child: TabBar(
                        padding: const EdgeInsets.only(top: 32),
                        indicatorColor: Color(accentColor),
                        labelColor: Color(accentColor),
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
