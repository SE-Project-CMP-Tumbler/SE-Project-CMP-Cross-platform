// ignore_for_file: cascade_invocations

import "dart:convert";
import "package:http/http.dart";
import "package:tumbler/Methods/api.dart";
import 'package:tumbler/Models/post_model.dart';
import "package:tumbler/Models/tag.dart";


/// to get the "tags" in "check out tags section
Future<List<Tag>> getTagsToFollow() async
{

  final List<Tag> checkoutTags=<Tag>[
  ];
  final Response res = await Api().fetchCheckOutTags();
  final Map<String, dynamic> response= jsonDecode(res.body);
  final List<dynamic> tags = response["response"]["tags"];
  if (response["meta"]["status"] == "200") {
    for (final Map<String, dynamic> tag in tags) {
      final Tag coTag = Tag(
        tagDescription: tag["tag_description"],
        tagImgUrl: tag["tag_image"],
        postsCount: tag["posts_count"],
      );
      final Map<String, dynamic> tagResponse= await
      getTagDetails(coTag.tagDescription!);
      if(tagResponse["meta"]["status"]==200)
        {
          coTag.isFollowed= tagResponse["response"]["followed"] as bool;
          coTag.followersCount= tagResponse["response"]["followers_number"];
          coTag.postsCount= tagResponse["response"]["posts_count"];
        }
      checkoutTags.add(coTag);
    }
  }

  return checkoutTags;
}

/// to get the "tags" in "check out tags section
Future<List<Tag>> getTrendingTagsToFollow() async
{
  final List<Tag> trendingTags=<Tag>[
  ];
  final Response res = await Api().fetchTrendingTags();
  final Map<String, dynamic> response= jsonDecode(res.body);
  final List<dynamic> tags = response["response"]["tags"];
  if (response["meta"]["status"] == "200") {
    for (final Map<String, dynamic> tag in tags) {
      final Tag coTag = Tag(
        tagDescription: tag["tag_description"],
        tagImgUrl: tag["tag_image"],
        postsCount: tag["posts_count"],
      );
      final Map<String, dynamic> tagResponse= await
      getTagDetails(coTag.tagDescription!);
      if(tagResponse["meta"]["status"]==200)
      {
        coTag.isFollowed= tagResponse["response"]["followed"] as bool;
        coTag.followersCount= tagResponse["response"]["followers_number"];
        coTag.postsCount= tagResponse["response"]["posts_count"];
      }
      trendingTags.add(coTag);
    }
  }

  return trendingTags;
}


/// to get the "posts" of each tag
Future<List<PostModel>> getTagPosts(final String tagDescription,
    {final bool recent=true,}) async
{
  List<PostModel> tagPosts=<PostModel>[
  ];
  final Response res = await Api().fetchTagPosts(tagDescription,recent: recent);
  final Map<String, dynamic> response= jsonDecode(res.body);
  final List<dynamic> posts = response["response"]["posts"];
  if (response["meta"]["status"] == "200") {
    tagPosts= await PostModel.fromJSON(posts, true);
  }

  return tagPosts;
}

/// to get more details of each tag
Future<Map<String, dynamic>> getTagDetails(final String tagDescription,) async
{
  final Response res = await Api().fetchTagsDetails(tagDescription);
  final Map<String, dynamic> response= jsonDecode(res.body);
  return response;
}
