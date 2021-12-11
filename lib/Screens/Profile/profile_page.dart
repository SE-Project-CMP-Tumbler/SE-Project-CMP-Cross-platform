// ignore_for_file: lines_longer_than_80_chars
import "dart:math" as math;

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/painting.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Providers/posts.dart";
import "package:tumbler/Screens/Profile/create_new_blog.dart";
import "package:tumbler/Screens/Settings/profile_settings.dart";
import "package:tumbler/Widgets/Post/profile_personal_post.dart";

/// Shows modal bottom sheet when
/// the user clicks on more vert icon button in a post.
void showEditPostProfileBottomSheet(final BuildContext ctx) {
  showModalBottomSheet<dynamic>(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: ctx,
    builder: (final _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Text(
            "Dec 19, 2019",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  onTap: () {},
                  title: const Text(
                    "Pin post",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: const Text(
                    "Mute notifications",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: const Text(
                    "Copy Link",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

/// Profile Page of the User
class ProfilePage extends StatefulWidget {
  /// constructor
  const ProfilePage({
    required final this.currentBlog,
    final Key? key,
  }) : super(key: key);

  /// takes the current blog index
  final int? currentBlog;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  TabController? tabController;
  int currentTab = 0;
  final GlobalKey<State<StatefulWidget>> greenKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> blueKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> orangeKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> yellowKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> purpleKey = GlobalKey();
  int currentOption = 0;
  int themeColor = 0xff001935;
  int themeTitleColor = 0xffffffff;
  int accentColor = 0xffffffff;
  late AnimationController loadingSpinnerAnimationController;

  List<Blog> blogs = <Blog>[];

  /// true when posts are loading.
  bool _isLoading = false;

  /// true when error occurred
  bool _error = false;

  ///true after first successful posts fetching.
  final bool _isInit = false;

  /// list of current home posts.
  List<Post> posts = <Post>[];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    /// Animation controller for the color varying loading spinner
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
    getBlogPosts();
  }

  Future<void> getBlogPosts() async {
    if (Provider.of<Posts>(context, listen: false).profilePosts.isEmpty) {
      if (int.tryParse(User.blogsIDs[User.currentProfile]) != null) {
        await refreshBlogPosts(
          context,
          int.parse(User.blogsIDs[User.currentProfile]),
        );
      }
    }
  }

  @override
  void dispose() {
    tabController!.dispose();
    SystemChrome.restoreSystemUIOverlays();
    loadingSpinnerAnimationController.dispose();
    super.dispose();
  }

  /// Responsible refreshing home page and fetch new post to show.
  Future<void> refreshBlogPosts(
    final BuildContext context,
    final int blogId,
  ) async {
    _error = false;
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Posts>(context, listen: false)
        .fetchSpecificBlogPosts(blogId)
        .then((final _) {
      setState(() {
        posts = Provider.of<Posts>(context, listen: false).profilePosts;
        _isLoading = false;
      });
    }).catchError((final Object? error) {
      setState(() {
        _isLoading = false;
        _error = true;
      });
      //showErrorDialog(context, error.toString());
    });
  }

  @override
  Widget build(final BuildContext context) {
    final Posts postsProv = Provider.of<Posts>(context);
    posts = postsProv.profilePosts;
    final List<String> blogUserNames =
        User.blogsNames + <String>["Create new tumblr"];
    String dropdownValue = User.blogsNames[User.currentProfile];
    final double _height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    final double _width = MediaQuery.of(context).size.width;
    final List<String> _tabs = <String>["Posts", "Likes", "Following"];
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        backgroundColor: Color(themeColor),
        body: NestedScrollView(
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
                      Container(
                        height: 0.35 * _height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage("assets/images/intro_3.jpg"),
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
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ), //editable
                                  child: Image.asset(
                                    "assets/images/intro_3.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              User.titles[User.currentProfile],
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
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: SizedBox(
                                        width: _width / 2,
                                        child: DropdownButton<String>(
                                          onChanged: (final String? value) {
                                            if (value ==
                                                blogUserNames[
                                                    blogUserNames.length - 1]) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute<
                                                    CreateNewBlog>(
                                                  builder: (
                                                    final BuildContext context,
                                                  ) =>
                                                      const CreateNewBlog(),
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                dropdownValue = value!;
                                                User.currentProfile = User
                                                    .blogsNames
                                                    .indexOf(value);
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
                                                (final String e) =>
                                                    DropdownMenuItem<String>(
                                                  value: e,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: <Widget>[
                                                        if (e ==
                                                            blogUserNames[
                                                                blogUserNames
                                                                        .length -
                                                                    1])
                                                          const Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                          )
                                                        else
                                                          Image.network(
                                                            User.avatars[blogUserNames
                                                                        .indexWhere(
                                                                      (
                                                                        final String
                                                                            element,
                                                                      ) =>
                                                                          element ==
                                                                          e,
                                                                    )] ==
                                                                    " "
                                                                ? "https://picsum.photos/200"
                                                                : User.avatars[User
                                                                    .currentProfile],
                                                            width: 35,
                                                            height: 35,
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
                                            final BuildContext context,
                                          ) =>
                                              blogUserNames
                                                  .map(
                                                    (final String e) => Align(
                                                      alignment:
                                                          Alignment.centerLeft,
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
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      ),
                                    ),
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
                                          onPressed: () {},
                                          splashColor: Colors.white10,
                                        ),
                                      ),
                                    ),
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
                                          onPressed: () {},
                                          splashColor: Colors.white10,
                                        ),
                                      ),
                                    ),
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
                                          onPressed: () {},
                                          splashColor: Colors.white10,
                                        ),
                                      ),
                                    ),
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
                                                  final BuildContext context,
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
                                ),
                              ),
                            )
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
            color: navy,
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
                        if (name == "Posts") {
                          return _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        loadingSpinnerAnimationController.drive(
                                      ColorTween(
                                        begin: Colors.blueAccent,
                                        end: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    await refreshBlogPosts(
                                      context,
                                      int.parse(
                                        User.blogsIDs[User.currentProfile],
                                      ),
                                    );
                                  },
                                  child: CustomScrollView(
                                    // The "controller" and "primary" members should be left
                                    // unset, so that the NestedScrollView can control this
                                    // inner scroll view.
                                    // If the "controller" property is set, then this scroll
                                    // view will not be associated with the NestedScrollView.
                                    // The PageStorageKey should be unique to this ScrollView;
                                    // it allows the list to remember its scroll position when
                                    // the tab view is not on the screen.
                                    key: PageStorageKey<String>(name),
                                    slivers: <Widget>[
                                      SliverOverlapInjector(
                                        // This is the flip side of the SliverOverlapAbsorber
                                        // above.
                                        handle: NestedScrollView
                                            .sliverOverlapAbsorberHandleFor(
                                          context,
                                        ),
                                      ),
                                      SliverPadding(
                                        padding:
                                            const EdgeInsets.only(bottom: 18),
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
                                                child: PersonalPost(
                                                  showEditPostBottomSheet:
                                                      showEditPostProfileBottomSheet,
                                                  post: posts.reversed
                                                      .toList()[index],
                                                ),
                                              );
                                            },
                                            // The childCount of the SliverChildBuilderDelegate
                                            // specifies how many children this inner list
                                            // has.
                                            childCount: posts.length,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        }
                        /**else if(name=="Likes")
                            return LikesTab(secondaryTextColor: floatingButtonColor,
                            posts: posts,);**/
                        else
                          return Container();
                      },
                    ),
                  )
                  .toList(),
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
