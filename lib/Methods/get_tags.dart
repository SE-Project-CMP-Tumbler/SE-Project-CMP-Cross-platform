import "dart:convert";
import "package:http/http.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/post.dart";
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
      print(tag.toString());
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
Future<List<Tag>> getTrendingTagsToFollow() async
{
  final List<Tag> trendingTags=<Tag>[
  ];
  final Response res = await Api().fetchTrendingTags();
  final Map<String, dynamic> response= jsonDecode(res.body);
  final List<dynamic> tags = response["response"]["tags"];
  if (response["meta"]["status"] == "200") {
    for (final Map<String, dynamic> tag in tags) {
      print(tag.toString());

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
Future<List<Post>> getTagPosts(final String tagDescription,
    {final bool recent=true,}) async
{
  final List<Post> tagPosts=<Post>[
  ];
  final Response res = await Api().fetchTagPosts(tagDescription,recent: recent);
  final Map<String, dynamic> response= jsonDecode(res.body);
  final List<dynamic> posts = response["response"]["posts"];
  if (response["meta"]["status"] == "200") {
    for (final Map<String, dynamic> post in posts) {
      final Post tagPost = Post(
          postId: post["post_id"],
          postBody: post["post_body"],
          postStatus: post["post_status"],
          postType: post["post_type"],
          blogId: post["blog_id"],
          blogUsername: post["blog_username"],
          blogAvatar: post["blog_avatar"],
          blogAvatarShape: post["blog_avatar_shape"],
          blogTitle: post["blog_title"],
          postTime: post["post_time"],
      );

      tagPosts.add(tagPost);
    }
  }

  return tagPosts;
}

