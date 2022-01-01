import "dart:math";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:sliver_header_delegate/sliver_header_delegate.dart";
import "package:sliver_tools/sliver_tools.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/urls.dart";
import "package:tumbler/Methods/follow_tags.dart";
import "package:tumbler/Methods/get_tags.dart";
import "package:tumbler/Methods/show_toast.dart" as toast;
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Widgets/Post/post_overview.dart";
import "package:tumbler/Widgets/Search/check_ou_tag.dart";

/// List of the Recent Post of this Tag
List<PostModel> recentPosts = <PostModel>[];

/// List of the Top Post of this Tag
List<PostModel> topPosts = <PostModel>[];

/// for showing the posts (recent, tops) of a specific tag
class TagPosts extends StatefulWidget {
  /// constructor, takes tag description and image and a random color only
  const TagPosts({
    required final this.bgColor,
    required final this.tag,
    final Key? key,
  }) : super(key: key);

  /// color theme of the page (random color)
  final Color bgColor;

  /// a tag object that carries information:
  /// tag background image, tag description, is followed or not
  final Tag tag;

  @override
  _TagPostsState createState() => _TagPostsState();
}

class _TagPostsState extends State<TagPosts> with TickerProviderStateMixin {
  late AnimationController loadingSpinnerAnimationController;
  final ScrollController _scrollControllerTop = ScrollController();
  final ScrollController _scrollControllerRecent = ScrollController();
  TabController? tabController;

  /// to indicate whether the posts is loading or not
  bool _isLoading = true;

  /// to indicate whether the user successfully followed this tag or not
  bool _followed = false;

  /// to indicate a loading of an unfollow tag request
  bool _proceedingFollowing = false;

  /// true when error occurred
  bool _error = false;

  /// true when more posts are loading.
  bool _isLoadingMoreTop = false;

  /// to indicate if we reached the max page count or not
  bool reachedMaxTop = false;

  /// the current page of the followed tags
  int currentPageTop = 1;

  /// true when more posts are loading.
  bool _isLoadingMoreRecent = false;

  /// to indicate if we reached the max page count or not
  bool reachedMaxRecent = false;

  /// the current page of the followed tags
  int currentPageRecent = 1;
  ScrollController? _scrollController;

  // ignore: unused_field
  int _currentTab = 0;

  // ignore: unused_field
  final int _postsCount = 0;

  Future<void> getRecentTagPosts() async {
    setState(() {
      currentPageTop = 1;
      currentPageRecent = 1;
      reachedMaxTop = false;
      reachedMaxRecent = false;
      _isLoading = true;
      _error = false;
    });

    /// get recent posts of the tag
    final List<PostModel> tagPosts = await getTagPosts(
      widget.tag.tagDescription!,
    ).catchError((final Object? error) {
      toast.showToast(
        "error from getting recent tags posts"
        "\n${error.toString()}",
      );
      setState(() {
        _isLoading = false;
        _error = true;
      });
    });
    setState(() {
      recentPosts = tagPosts;
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getTopTagPosts() async {
    setState(() {
      currentPageTop = 1;
      currentPageRecent = 1;
      reachedMaxTop = false;
      reachedMaxRecent = false;
      _isLoading = true;
      _error = false;
    });

    /// get top posts of the tag
    final List<PostModel> tagTopPosts = await getTagPosts(
      widget.tag.tagDescription!,
      recent: false,
    ).catchError((final Object? error) {
      toast.showToast(
        "error from getting recent tags posts"
        "\n${error.toString()}",
      );
      setState(() {
        _isLoading = false;
        _error = true;
      });
    });
    setState(() {
      topPosts = tagTopPosts;
    });

    setState(() {
      _isLoading = false;
    });
  }

  // ignore: avoid_void_async
  Future<void> fetchAllPosts() async {
    /// get recent posts of the tag
    final List<PostModel> tagPosts = await getTagPosts(
      widget.tag.tagDescription!,
    ).catchError((final Object? error) {
      toast.showToast(
        "error from getting recent tags posts"
        "\n${error.toString()}",
      );
      setState(() {
        _isLoading = false;
        _error = true;
      });
    });

    recentPosts = tagPosts;

    /// get top posts of the tag
    final List<PostModel> tagTopPosts = await getTagPosts(
      widget.tag.tagDescription!,
      recent: false,
    ).catchError((final Object? error) {
      toast.showToast(
        "error from getting top tags posts"
        "\n${error.toString()}",
      );
      setState(() {
        _isLoading = false;
        _error = true;
      });
    });

    topPosts = tagTopPosts;
    _isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  // ignore: avoid_void_async
  void getMoreTopTagPosts() async {
    if (reachedMaxTop) // nothing more to fetch
    {
      return;
    }
    setState(() {
      _isLoadingMoreTop = true;
      _error = false;
    });

    /// get recent posts of the tag
    final List<PostModel> tagPosts = await getTagPosts(
      widget.tag.tagDescription!,
      recent: false,
      page: currentPageTop,
    ).catchError((final Object? error) {
      toast.showToast(
        "error from getting top tags posts"
        "\n${error.toString()}",
      );
      setState(() {
        _isLoadingMoreTop = false;
        _error = true;
      });
    });
    if (tagPosts.isNotEmpty) {
      setState(() {
        if (currentPageTop == 1)
          topPosts = tagPosts;
        else
          topPosts.addAll(tagPosts);
      });
    } else {
      setState(() {
        reachedMaxTop = true;
      });
    }
    setState(() {
      _isLoadingMoreTop = false;
    });
  }

  // ignore: avoid_void_async
  void getMoreRecentTagPosts() async {
    if (reachedMaxRecent) // nothing more to fetch
    {
      return;
    }
    setState(() {
      _isLoadingMoreRecent = true;
      _error = false;
    });

    /// get recent posts of the tag
    final List<PostModel> tagPosts = await getTagPosts(
      widget.tag.tagDescription!,
      page: currentPageRecent,
    ).catchError((final Object? error) {
      toast.showToast(
        "error from getting recent tags posts"
        "\n${error.toString()}",
      );
      setState(() {
        _isLoadingMoreRecent = false;
        _error = true;
      });
    });
    if (tagPosts.isNotEmpty) {
      setState(() {
        if (currentPageRecent == 1)
          recentPosts = tagPosts;
        else
          recentPosts.addAll(tagPosts);
      });
    } else {
      setState(() {
        reachedMaxRecent = true;
      });
    }
    setState(() {
      _isLoadingMoreRecent = false;
    });
  }

  // ignore: always_specify_types
  late Animation _colorTween;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    /// Animation controller for the color varying loading spinner
    tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollControllerRecent.addListener(() {
      if (_scrollControllerRecent.position.pixels >=
              _scrollControllerRecent.position.maxScrollExtent &&
          !_isLoading &&
          !_isLoadingMoreRecent) {
        currentPageRecent++;
        getMoreRecentTagPosts();
      }
    });
    _scrollControllerTop.addListener(() {
      if (_scrollControllerTop.position.pixels >=
              _scrollControllerTop.position.maxScrollExtent &&
          !_isLoading &&
          !_isLoadingMoreTop) {
        currentPageTop++;
        getMoreTopTagPosts();
      }
    });
    loadingSpinnerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingSpinnerAnimationController.repeat();
    _followed = widget.tag.isFollowed ?? false;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    controller.repeat();
    _colorTween = controller.drive(
      ColorTween(
        begin: Colors.deepPurpleAccent,
        end: floatingButtonColor,
      ),
    );
    fetchAllPosts();
  }

  @override
  void dispose() {
    loadingSpinnerAnimationController.dispose();
    tabController!.dispose();
    _scrollControllerRecent.dispose();
    _scrollControllerTop.dispose();
    _scrollController!.dispose();
    controller.dispose();
    super.dispose();
  }

  /// a state variable to hide the follow button on scroll
  bool isScrolled = false;

  @override
  Widget build(final BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    final List<String> _tabs = <String>["Recent", "Top"];
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: widget.bgColor,
        // ignore: always_specify_types
        body: NotificationListener(
          onNotification: (final Object? t) {
            if (t is ScrollNotification) {
              if (_scrollController!.position.pixels > 70) {
                if (mounted)
                  setState(() {
                    isScrolled = true;
                  });
              } else {
                if (mounted)
                  setState(() {
                    isScrolled = false;
                  });
              }
            }
            return true;
          },
          child: NestedScrollView(
            floatHeaderSlivers: true,
            controller: _scrollController,
            headerSliverBuilder:
                (final BuildContext context, final bool value) {
              return <Widget>[
                SliverStack(
                  children: <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverPersistentHeader(
                        floating: true,
                        pinned: true,
                        delegate: FlexibleHeaderDelegate(
                          leading: IconButton(
                            icon: const Icon(
                              CupertinoIcons.arrow_left,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          statusBarHeight: MediaQuery.of(context).padding.top,
                          expandedHeight: 250,
                          background: MutableBackground(
                            animationDuration: Duration.zero,
                            expandedWidget: GestureDetector(
                              onTap: () {},
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Image.network(
                                    widget.tag.tagImgUrl ?? tumblerImgUrl,
                                    width: _width,
                                    height: 280,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                            collapsedWidget: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Image.network(
                                  widget.tag.tagImgUrl ?? tumblerImgUrl,
                                  width: _width,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  color: Colors.black26,
                                  width: _width,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {},
                            ),
                          ],
                          collapsedElevation: 0,
                          children: <Widget>[
                            FlexibleTextItem(
                              text: "#${widget.tag.tagDescription}",
                              expandedAlignment: Alignment.bottomLeft,
                              collapsedAlignment: Alignment.bottomLeft,
                              collapsedPadding: const EdgeInsets.only(
                                top: 16,
                                bottom: 16,
                                left: 65,
                              ),
                              expandedMargin: const EdgeInsets.only(
                                top: 16,
                                bottom: 110,
                                left: 32,
                              ),
                              collapsedStyle: TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                color: widget.bgColor.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              expandedStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500,
                                color: widget.bgColor.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 34,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: _width,
                            height: 280,
                          ),
                          Positioned(
                            bottom: 10,
                            left: 32,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: isScrolled ? 0 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${widget.tag.postsCount} posts",
                                    style: TextStyle(
                                      color: widget.bgColor.computeLuminance() >
                                              0.5
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    textScaleFactor: 1.2,
                                  ),
                                  Text(
                                    "${widget.tag.followersCount}"
                                    " followers",
                                    style: TextStyle(
                                      color: widget.bgColor.computeLuminance() >
                                              0.5
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    textScaleFactor: 1.2,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (mounted)
                                            setState(() {
                                              _proceedingFollowing = true;
                                            });
                                          if (!_followed) {
                                            if (widget.tag.tagDescription !=
                                                null) {
                                              final bool succeeded =
                                                  await followTag(
                                                widget.tag.tagDescription!,
                                              );
                                              if (succeeded) {
                                                showSnackBar(
                                                  context,
                                                  "Great!,"
                                                  " you are now following "
                                                  "all about #"
                                                  "${widget.tag.tagDescription}",
                                                );
                                                if (mounted)
                                                  setState(() {
                                                    _followed = true;
                                                  });
                                              } else {
                                                showSnackBar(
                                                  context,
                                                  "OOPS, something went wrong 😢",
                                                );
                                              }
                                            }
                                          } else {
                                            // ignore: invariant_booleans
                                            if (widget.tag.tagDescription !=
                                                null) {
                                              final bool succeeded =
                                                  await unFollowTag(
                                                widget.tag.tagDescription!,
                                              );
                                              if (succeeded) {
                                                showSnackBar(
                                                  context,
                                                  "Don't worry, u won't be"
                                                  " bothered by this tag again",
                                                );
                                                if (mounted)
                                                  setState(() {
                                                    _followed = false;
                                                  });
                                              } else {
                                                showSnackBar(
                                                  context,
                                                  "OOPS, something went wrong 😢",
                                                );
                                              }
                                            }
                                          }
                                          if (mounted)
                                            setState(() {
                                              _proceedingFollowing = false;
                                            });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            _followed
                                                ? Colors.transparent
                                                : widget.bgColor,
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: _followed
                                                    ? widget.bgColor
                                                    : Colors.transparent,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: _proceedingFollowing
                                            ? const CircularProgressIndicator()
                                            : Text(
                                                _followed
                                                    ? "UnFollow"
                                                    : "Follow",
                                                style: TextStyle(
                                                  color: _followed
                                                      ? widget.bgColor
                                                      : widget.bgColor
                                                                  .computeLuminance() >
                                                              0.5
                                                          ? Colors.black
                                                          : Colors.white,
                                                ),
                                                textScaleFactor: 1.2,
                                              ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            widget.bgColor,
                                          ),
                                          shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                            ),
                                          ),
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                              horizontal: 24,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "New Post",
                                          textScaleFactor: 1.2,
                                          style: TextStyle(
                                            color: widget.bgColor
                                                        .computeLuminance() >
                                                    0.5
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
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
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 60,
                    maxHeight: 60,
                    child: Container(
                      color: widget.bgColor,
                      child: TabBar(
                        controller: tabController,
                        indicatorColor: widget.bgColor.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        labelColor: widget.bgColor.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        onTap: (final int index) async {
                          setState(() {
                            _currentTab = index;
                          });
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
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    color: widget.bgColor,
                    child: TabBarView(
                      controller: tabController,
                      // These are the contents of the tab views, below the tabs.
                      children: _tabs
                          .map(
                            (final String name) => RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  currentPageTop = 1;
                                  currentPageRecent = 1;
                                  reachedMaxTop = false;
                                  reachedMaxRecent = false;
                                  _isLoading = true;
                                  _error = false;
                                });

                                if (name == _tabs[0])
                                  // Recent
                                  await getRecentTagPosts();
                                else
                                  await getTopTagPosts();
                              },
                              child: _error
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(top: _height / 6),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/error.png",
                                          ),
                                          const Text(
                                            "Something bad happened T_T\n try again later",
                                            textScaleFactor: 1.5,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Builder(
                                      // This Builder is needed to provide a BuildContext that is
                                      // "inside" the NestedScrollView, so that
                                      // sliverOverlapAbsorberHandleFor() can find the
                                      // NestedScrollView.
                                      builder: (final BuildContext context) {
                                        if (name == _tabs[0]) {
                                          if (recentPosts.isNotEmpty)
                                            return Stack(
                                              alignment: Alignment.topCenter,
                                              children: <Widget>[
                                                ListView.builder(
                                                  controller:
                                                      _scrollControllerRecent,
                                                  itemCount: recentPosts.length,
                                                  itemBuilder: (
                                                    final BuildContext context,
                                                    final int index,
                                                  ) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        bottom: 18,
                                                      ),
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: PostOutView(
                                                          post: recentPosts[
                                                              index],
                                                          index: index, // dump
                                                          isTagPost: true,
                                                          page: 7,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                if (_isLoadingMoreRecent)
                                                  Positioned(
                                                    left: 0,
                                                    bottom: 0,
                                                    child: SizedBox(
                                                      width: _height,
                                                      child:
                                                          LinearProgressIndicator(
                                                        minHeight: 8,
                                                        valueColor: _colorTween
                                                            as Animation<
                                                                Color?>,
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  Container(),
                                              ],
                                            );
                                          else
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: _height / 6,
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    "assets/images/404.png",
                                                  ),
                                                  const Text(
                                                    "OOPS, there's nothing here",
                                                    textScaleFactor: 1.5,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                        } else {
                                          if (topPosts.isNotEmpty)
                                            return Stack(
                                              alignment: Alignment.topCenter,
                                              children: <Widget>[
                                                ListView.builder(
                                                  controller:
                                                      _scrollControllerTop,
                                                  itemCount: topPosts.length,
                                                  itemBuilder: (
                                                    final BuildContext context,
                                                    final int index,
                                                  ) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        bottom: 18,
                                                      ),
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: PostOutView(
                                                          post: topPosts[index],
                                                          index: index, // dump
                                                          isTagPost: true,
                                                          page: 8,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                if (_isLoadingMoreTop)
                                                  Positioned(
                                                    left: 0,
                                                    bottom: 0,
                                                    child: SizedBox(
                                                      width: _height,
                                                      child:
                                                          LinearProgressIndicator(
                                                        minHeight: 8,
                                                        valueColor: _colorTween
                                                            as Animation<
                                                                Color?>,
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  Container(),
                                              ],
                                            );
                                          else
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: _height / 6,
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    "assets/images/404.png",
                                                  ),
                                                  const Text(
                                                    "OOPS, there's nothing here",
                                                    textScaleFactor: 1.5,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                        }
                                      },
                                    ),
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
  double get maxExtent => max(maxHeight, minHeight);

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
