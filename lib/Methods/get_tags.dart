import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";

/// to get the "tags" in "check out tags section
Future<List<Tag>> getTagsToFollow() async {
  final List<Tag> checkoutTags = <Tag>[];
  final Map<String, dynamic> response = await Api().fetchCheckOutTags();
  final List<dynamic> tags = response["response"]["tags"];
  if (response["meta"]["status"] == "200") {
    for (final Map<String, dynamic> tag in tags) {
      // print(tag.toString());
      final Tag coTag = Tag(
        tagDescription: tag["tag_description"],
        tagImgUrl: tag["tag_image"],
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
      // print(tag.toString());

      final Tag coTag = Tag(
        tagDescription: tag["tag_description"],
        tagImgUrl: tag["tag_image"],
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
}) async {
  List<PostModel> tagPosts = <PostModel>[];
  final Map<String, dynamic> response =
      await Api().fetchTagPosts(tagDescription, recent: recent);
  final List<dynamic> posts = response["response"]["posts"];
  if (response["meta"]["status"] == "200") {
    tagPosts = await PostModel.fromJSON(posts, true);
  }

  return tagPosts;
}
