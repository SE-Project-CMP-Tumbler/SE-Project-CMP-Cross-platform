import "dart:developer";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/urls.dart";
import "package:tumbler/Methods/follow_tags.dart";
import "package:tumbler/Methods/get_tags.dart";
import "package:tumbler/Methods/show_toast.dart" as toast;
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Providers/tags.dart";
import "package:tumbler/Screens/Search/search_query.dart";
import "package:tumbler/Widgets/Search/check_ou_tag.dart";

/// a page to manage followings
class ManageTags extends StatefulWidget {
  /// constructor
  const ManageTags({final Key? key}) : super(key: key);

  @override
  _ManageTagsState createState() => _ManageTagsState();
}

class _ManageTagsState extends State<ManageTags> with TickerProviderStateMixin {
  late AnimationController controller;

  /// true when posts are loading.
  bool _isLoading = false;

  /// true when more posts are loading.
  bool _isLoadingMore = false;

  /// true when error occurred
  bool _error = false;

  /// to indicate whether the user successfully followed this tag or not
  // ignore: prefer_final_fields, unused_field
  bool _followed = false;

  /// to indicate a loading of an unfollow tag request
  // ignore: unused_field, prefer_final_fields
  bool _proceedingFollowing = false;

  /// to indicate if we reached the max page count or not
  bool reachedMax = false;

  /// the current page of the followed tags
  int currentPage = 1;

  /// single child scroll controller, to indicate
  /// if i reached the end of the screen or not
  final ScrollController _scrollController = ScrollController();

  /// get the list of tags followed
  Future<void> getFollowedTags() async {
    setState(() {
      _isLoading = true;
      _error = false;
      reachedMax = false;
      currentPage = 1;
    });
    final List<Tag> tags =
        await getUserFollowedTags().catchError((final Object? error) {
      toast.showToast(
        "error from getting followed tags"
        "\n${error.toString()}",
      );
      setState(() {
        _error = true;
        _isLoading = false;
      });
    });
    setState(() {
      followedTags = tags;
    });

    setState(() {
      _isLoading = false;
    });
  }

  /// get the list of tags followed
  Future<void> getMoreFollowedTags() async {
    if (reachedMax) // nothing more to fetch
    {
      return;
    }
    setState(() {
      _error = false;
      _isLoadingMore = true;
      log("getting more...");
    });
    final List<Tag> tags = await getUserFollowedTags(page: currentPage)
        .catchError((final Object? error) {
      toast.showToast(
        "error from getting followed tags"
        "\n${error.toString()}",
      );
      setState(() {
        _error = true;
        _isLoadingMore = false;
      });
    });
    if (tags.isNotEmpty) {
      setState(() {
        if (currentPage > 1)
          followedTags.addAll(tags);
        else
          followedTags = tags;
      });
    } else {
      setState(() {
        reachedMax = true;
      });
    }

    setState(() {
      _isLoadingMore = false;
    });
  }

  /// list of the tags that the user follows
  List<Tag> followedTags = <Tag>[];

  // ignore: always_specify_types
  late Animation _colorTween;
  @override
  void initState() {
    super.initState();
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
    _scrollController.addListener(() {
      if (!reachedMax) {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent &&
            !_isLoading &&
            !_isLoadingMore) {
          currentPage++;
          getMoreFollowedTags();
        }
      }
    });
    getFollowedTags();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    controller.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.white,
            size: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: navy,
        title: const Text(
          "Tags you follow",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<SearchQuery>(
                  builder: (final BuildContext context) => SearchQuery(
                    recommendedTags:
                        Provider.of<Tags>(context, listen: false).trendingTags,
                  ),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.plus,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? Padding(
                  padding: EdgeInsets.only(top: _height / 6),
                  child: Column(
                    children: <Widget>[
                      Image.asset("assets/images/error.png"),
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
              : followedTags.isNotEmpty
                  ? Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: followedTags.length,
                          itemBuilder:
                              (final BuildContext context, final int index) {
                            return FollowedTagComponent(
                              key: Key(followedTags[index].tagDescription!),
                              followedTag: followedTags[index],
                            );
                          },
                        ),
                        if (_isLoadingMore)
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: _height,
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                valueColor: _colorTween as Animation<Color?>,
                              ),
                            ),
                          )
                        else
                          Container(),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: _height / 6),
                      child: Column(
                        children: <Widget>[
                          Image.asset("assets/images/404.png"),
                          const Text(
                            "OOPS, there's nothing here",
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
    );
  }
}

/// for rendering each followed tag
class FollowedTagComponent extends StatefulWidget {
  /// constructor. takes the followed tag object
  const FollowedTagComponent({
    required final this.followedTag,
    final Key? key,
  }) : super(key: key);

  /// the followed tag object
  final Tag followedTag;

  @override
  State<FollowedTagComponent> createState() => _FollowedTagComponentState();
}

class _FollowedTagComponentState extends State<FollowedTagComponent>
    with TickerProviderStateMixin {
  /// true when error occurred
  // ignore: prefer_final_fields, unused_field
  bool _error = false;

  /// to indicate whether the user successfully followed this tag or not
  bool _followed = false;

  /// to indicate a loading of an unfollow tag request
  bool _proceedingFollowing = false;
  // ignore: always_specify_types, unused_field
  late Animation _colorTween;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    _followed = widget.followedTag.isFollowed!;
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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(2),
        child: SizedBox(
          width: 45,
          height: 45,
          child: Image.network(
            widget.followedTag.tagImgUrl ?? tumblerImgUrl,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "#${widget.followedTag.tagDescription ?? ""}",
            textScaleFactor: 1.2,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${widget.followedTag.postsCount ?? ""} posts",
            textScaleFactor: 1.2,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
      trailing: ElevatedButton(
        onPressed: () async {
          if (mounted)
            setState(() {
              _proceedingFollowing = true;
            });
          if (!_followed) {
            if (widget.followedTag.tagDescription != null) {
              final bool succeeded =
                  await followTag(widget.followedTag.tagDescription!);
              if (succeeded) {
                showToast(
                  context,
                  "Great!,"
                  " you are now following "
                  "all about #"
                  "${widget.followedTag.tagDescription}",
                );
                if (mounted)
                  setState(() {
                    _followed = true;
                  });
              } else {
                showToast(
                  context,
                  "OOPS, something went wrong 😢",
                );
              }
            }
          } else {
            // ignore: invariant_booleans
            if (widget.followedTag.tagDescription != null) {
              final bool succeeded =
                  await unFollowTag(widget.followedTag.tagDescription!);
              if (succeeded) {
                showToast(
                  context,
                  "Don't worry, u won't be"
                  " bothered by this tag again",
                );
                if (mounted)
                  setState(() {
                    _followed = false;
                  });
              } else {
                showToast(
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
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: _followed
                  ? const BorderSide(color: Colors.transparent)
                  : const BorderSide(color: Colors.white, width: 2),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            _followed ? floatingButtonColor : Colors.transparent,
          ),
        ),
        child: Text(
          _proceedingFollowing
              ? "Loading.."
              : _followed
                  ? "Following"
                  : "Follow",
          style: TextStyle(
            color: _followed ? navy : Colors.white,
          ),
          textScaleFactor: 1.2,
        ),
      ),
    );
  }
}
