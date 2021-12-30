// ignore_for_file: cascade_invocations, prefer_final_fields

import "package:flutter/material.dart";
import "package:random_color/random_color.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/get_all_blogs.dart";
import "package:tumbler/Methods/get_tags.dart";
import "package:tumbler/Methods/random_posts.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";

/// to provide the tags to the search page

class Tags with ChangeNotifier {
  bool _isLoaded = false;
  List<Tag> _followedTags = <Tag>[];
  List<Blog> _checkOutBlogs = <Blog>[];
  List<PostModel> _randomPosts = <PostModel>[];
  List<Tag> _tagsToFollow = <Tag>[];
  List<Tag> _trendingTags = <Tag>[];
  Map<Blog, Color> _blogsBgColors = <Blog, Color>{};
  Map<Tag, Color> _tagsBgColors = <Tag, Color>{};
  Map<Tag, List<PostModel>> _tagsPosts = <Tag, List<PostModel>>{};

  /// Returns isLoaded
  bool get isLoaded {
    return _isLoaded;
  }

  /// Returns all followed tags
  List<Tag> get followedTags {
    return <Tag>[..._followedTags];
  }

  /// Returns all suggested blogs
  List<Blog> get checkOutBlogs {
    return <Blog>[..._checkOutBlogs];
  }

  /// Returns all random posts "Try these posts"
  List<PostModel> get randomPosts {
    return <PostModel>[..._randomPosts];
  }

  /// Returns all "Check out" tags
  List<Tag> get tagsToFollow {
    return <Tag>[..._tagsToFollow];
  }

  /// Returns all trending tags
  List<Tag> get trendingTags {
    return <Tag>[..._trendingTags];
  }

  /// Returns all blogs random bg colors
  Map<Blog, Color> get blogsBgColors {
    return <Blog, Color>{..._blogsBgColors};
  }

  /// Returns all tags random bg
  Map<Tag, Color> get tagsBgColors {
    return <Tag, Color>{..._tagsBgColors};
  }

  /// Returns all followed tags
  Map<Tag, List<PostModel>> get tagsPosts {
    return <Tag, List<PostModel>>{..._tagsPosts};
  }

  /// fetch tags through http get request.

  Future<void> fetchAndSetFollowedTags({final int page = 1}) async {
    /// clear all loaded post.
    final Map<String, dynamic> encodedRes =
        await Api().fetchTagsFollowed(page: page);

    /// checking the status code of the received response.
    if (int.tryParse(encodedRes["meta"]["status"]) != null &&
        int.tryParse(encodedRes["meta"]["status"]) != 200)
      throw HttpException(encodedRes["meta"]["msg"]);

    /// set _followedTags list.
    final List<dynamic> tagsList = encodedRes["response"]["tags"];
    // ignore: prefer_final_locals
    List<Tag> tagsFollowed = <Tag>[];


    for (int i = 0; i < tagsList.length; i++) {
      final Tag temp = Tag(
        tagDescription: tagsList[i]["tag_description"],
        tagImgUrl: tagsList[i]["tag_image"],
        isFollowed: tagsList[i]["followed"] as bool,
        followersCount: tagsList[i]["followers_number"],
        postsCount: tagsList[i]["posts_count"],
      );

      tagsFollowed.add(temp);
    }
    if (page == 1)
      _followedTags = tagsFollowed;
    else
      _followedTags.addAll(tagsFollowed);
    notifyListeners();
  }

  /// Responsible for reloading all explore screen results
  Future<void> refreshSearchPage(
    final BuildContext context,
  ) async {
    _isLoaded = false;
    notifyListeners();

    /// get followed tags
    // ignore: always_specify_types
    await fetchAndSetFollowedTags().catchError((final Object? error) {
      showToast(
        "error from getting followed tags"
        "\n${error.toString()}",
      );
    });

    /// get random suggesting tags
    await getTagsToFollow().then((final List<Tag> value) {
      _tagsToFollow = value;
      for (int i = 0; i < value.length; i++) {
        _tagsBgColors[value[i]] = RandomColor().randomColor();
      }
      notifyListeners();
    }).catchError((final Object? error) {
      showToast(
        "error on random suggesting tags\n"
        "${error.toString()}",
      );
    });

    /// get random blogs
    await getRandomBlogs().then((final List<Blog> value) {
      _checkOutBlogs.clear();
      _checkOutBlogs = value;
      for (int i = 0; i < value.length; i++) {
        _blogsBgColors[value[i]] = RandomColor().randomColor();
      }
      notifyListeners();
    }).catchError((final Object? error) {
      showToast("error on check out blogs\n${error.toString()}");
    });

    /// get random posts "try these posts"
    await getRandomPosts().then((final List<PostModel> value) {
      _randomPosts.clear();
      _randomPosts = value;
      notifyListeners();
    }).catchError((final Object? error) {
      showToast(
        "error on check out posts\n${error.toString()}",
      );
    });

    /// get trending tags
    await getTrendingTagsToFollow().then((final List<Tag> value) async {
      if (value.length <= 9) {
        _trendingTags.clear();
        _trendingTags = value;
        notifyListeners();
      } else {
        _trendingTags = <Tag>[];
        for (int i = 0; i < 9; i++) {
          _trendingTags.add(value[i]);
          notifyListeners();
        }
      }
      notifyListeners();

      /// for each trending tag, get their recent posts
      for (final Tag tTag in trendingTags) {
        await getTagPosts(tTag.tagDescription!)
            .then((final List<PostModel> value) {
          _tagsPosts[tTag] = value;
          notifyListeners();
        }).catchError((final Object? error) {
          showToast("from get tag posts \n${error.toString()}");
        });
      }
      notifyListeners();
    }).catchError((final Object? error) {
      showToast("from get trending tags \n${error.toString()}");
    });

    _isLoaded = true;
    notifyListeners();
  }

  /// to reset all lists
  void resetAll() {
    _isLoaded = false;
    _followedTags.clear();
    _checkOutBlogs.clear();
    _randomPosts.clear();
    _tagsToFollow.clear();
    _trendingTags.clear();
    _blogsBgColors.clear();
    _tagsBgColors.clear();
    _tagsPosts.clear();
  }

  /// Responsible for retrieving more suggesting blogs for pagination purpose
  Future<void> getMoreCheckOutBlogs(final int page) async {
    /// get random blogs
    await getRandomBlogs(page: page).then((final List<Blog> value) {
      if (page == 1)
        _checkOutBlogs = value;
      else
        _checkOutBlogs.addAll(value);
      for (int i = 0; i < value.length; i++) {
        _blogsBgColors[value[i]] = RandomColor().randomColor();
      }
      notifyListeners();
    }).catchError((final Object? error) {
      showToast("error on getting more check out blogs\n${error.toString()}");
    });
  }
}
