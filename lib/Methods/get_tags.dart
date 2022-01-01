/// ## Tags Retrieving Methods
/// to retrieve lists of all kinds of tags in the app
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Screens/Search/manage_tags.dart";
import "package:tumbler/Screens/Search/search_page.dart";
import "package:tumbler/Screens/Search/tag_posts.dart";
import "package:tumbler/Widgets/Search/check_out_tags.dart";
import "package:tumbler/Widgets/Search/trendings.dart";

/// Get the [Tag]s for [CheckOutTags] section in [SearchPage]
/// this function calls the [Api.fetchCheckOutTags]
/// to get that suggested [Tag]s
/// it then parses the Json Decoded response into a list of [Tag]s
/// if the status is "200" and returns that list, otherwise,
/// it returns an empty list.
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

/// Get the [Tag]s for [Trending] section in [SearchPage]
/// this function calls the [Api.fetchTrendingTags]
/// to get that trending [Tag]s
/// it then parses the Json Decoded response into a list of [Tag]s
/// if the status is "200" it returns that list, otherwise,
/// it returns an empty list.
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

/// Get the [PostModel]s of [TagPosts] page for each [tagDescription]
/// this function calls the [Api.fetchTagPosts]
/// to get that trending [PostModel]s
/// it then parses the Json Decoded response into a list of [PostModel]s
/// if the status is "200" it returns that list, otherwise,
/// it returns an empty list.
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
    tagPosts = await PostModel.fromJSON(posts);
  }

  return tagPosts;
}


// Get all data of the [Tag] using its [tagDescription]
/// this function calls the [Api.fetchTagsDetails]
/// and returns its response
/// "not used in the project"
Future<Map<String, dynamic>> getTagDetails(
  final String tagDescription,
) async {
  final Map<String, dynamic> response =
      await Api().fetchTagsDetails(tagDescription);
  return response;
}

/// to get all the [Tag]s followed by the user to display them in
/// [ManageTags] and [SearchPage]
/// this function calls the [Api.fetchTagsFollowed]
/// and parses its Json Decoded response to a list of [Tag]s
/// followed by the current user, but if the response is not = 200
/// it throws an exception with the response msg
Future<List<Tag>> getUserFollowedTags({final int page = 1}) async {
  /// clear all loaded tags.
  final Map<String, dynamic> encodedRes = await Api().fetchTagsFollowed(
    page: page,
  );

  /// checking the status code of the received response.
  if (int.tryParse(encodedRes["meta"]["status"]) != null &&
      int.tryParse(encodedRes["meta"]["status"]) != 200)
    throw HttpException(encodedRes["meta"]["msg"]);
  final List<Tag> tagsFollowed = <Tag>[];

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
