// ignore_for_file: cascade_invocations


import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";

/// to get the "tags" in "check out tags section
Future<List<Tag>> getTagsToFollow() async {
  final List<Tag> checkoutTags = <Tag>[];
  final Map<String, dynamic> response = await Api().fetchCheckOutTags();
  final List<dynamic> tags = response["response"]["tags"];
  if (response["meta"]["status"] == "200") {
    for (final Map<String, dynamic> tag in tags) {
      final Tag coTag = Tag(
        tagDescription: tag["tag_description"],
        tagImgUrl: tag["tag_image"],
        isFollowed: tag["followed"] as bool,
        followersCount: tag["followers_number"],
        postsCount: tag["posts_count"],
      );
      checkoutTags.add(coTag);
    }
  }

  return checkoutTags;
}

/// to get the "tags" in "check out tags section
Future<List<Tag>> getTrendingTagsToFollow() async {
  final List<Tag> trendingTags = <Tag>[];
  final Map<String, dynamic> response = await Api().fetchTrendingTags();
  final List<dynamic> tags = response["response"]["tags"];

  if (response["meta"]["status"] == "200") {
    for (final Map<String, dynamic> tag in tags) {
      final Tag coTag = Tag(
        tagDescription: tag["tag_description"],
        tagImgUrl: tag["tag_image"],
        isFollowed: tag["followed"] as bool,
        followersCount: tag["followers_number"],
        postsCount: tag["posts_count"],
      );

      trendingTags.add(coTag);
    }
  }

  return trendingTags;
}

/// to get the "posts" of each tag
Future<List<PostModel>> getTagPosts(
  final String tagDescription, {
  final bool recent = true,
  final int page = 1,
}) async {
  List<PostModel> tagPosts = <PostModel>[];
  final Map<String, dynamic> response = await Api().fetchTagPosts(
    tagDescription,
    recent: recent,
    page: page,
  );

  final List<dynamic> posts = response["response"]["posts"];
  if (response["meta"]["status"] == "200") {
    tagPosts = await PostModel.fromJSON(posts, true);
  }

  return tagPosts;
}

/// to get more details of each tag
Future<Map<String, dynamic>> getTagDetails(
  final String tagDescription,
) async {
  final Map<String, dynamic> response =
      await Api().fetchTagsDetails(tagDescription);
  return response;
}

/// to get all the tags followed by the user
Future<List<Tag>> getUserFollowedTags({final int page = 1}) async {
  /// clear all loaded tags.
  final Map<String, dynamic> encodedRes = await Api().fetchTagsFollowed(
    page: page,
  );

  /// checking the status code of the received response.
  if (int.tryParse(encodedRes["meta"]["status"]) != null &&
      int.tryParse(encodedRes["meta"]["status"]) != 200)
    throw HttpException(encodedRes["meta"]["msg"]);
  // ignore: prefer_final_locals
  List<Tag> tagsFollowed = <Tag>[];

  /// set _followedTags list.
  final List<dynamic> tagsList = encodedRes["response"]["tags"];

  for (int i = 0; i < tagsList.length; i++) {
    final Tag temp = Tag(
      tagDescription: tagsList[i]["tag_description"],
      tagImgUrl: tagsList[i]["tag_image"],
      isFollowed: tagsList[i]["followed"] as bool,
      followersCount: tagsList[i]["followers_number"],
      postsCount: tagsList[i]["posts_count"] ?? 0,
    );

    tagsFollowed.add(temp);
  }
  return tagsFollowed;
}
