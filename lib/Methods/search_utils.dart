import "dart:convert";
import 'package:flutter/material.dart';
import "package:http/http.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post.dart";
import "package:tumbler/Models/tag.dart";



/// to get the "autocomplete words"
Future<List<String>> getAutoComplete(final String word,) async
{
  final List<String> autoCompWords=<String>[
  ];
  if(word.length>1) {
    final Response res = await Api().fetchAutoComplete(word);
    final Map<String, dynamic> response = jsonDecode(res.body);
    print(response);
    if (response["meta"]["status"] == "200") {
      final List<dynamic> words = response["response"]["words"];
      for (final Map<String, dynamic> wordResult in words) {
        final String autoCompWord = wordResult["word"];
        autoCompWords.add(autoCompWord);
      }
    }
  }
  return autoCompWords;
}

/// to get the "autocomplete words"
Future<List<List<dynamic>>> getSearchResults(final String word,) async
{
  final List<Post> postsResults=<Post>[
  ];
  final List<Tag> tagsResults=<Tag>[
  ];
  final List<Blog> blogResults=<Blog>[
  ];

    final Response res = await Api().fetchSearchResults(word);
    final Map<String, dynamic> response = jsonDecode(res.body);
    final List<dynamic> posts = response["response"]["posts"]["posts"];
    final List<dynamic> tags = response["response"]["tags"]["tags"];
    final List<dynamic> blogs = response["response"]["blogs"]["blogs"];
    if (response["meta"]["status"] == "200") {
      for (final Map<String, dynamic> postResult in posts) {
        print(postResult);
        final Post post = Post(
          postId: postResult["post_id"],
          postBody: postResult["post_body"],
          postStatus: postResult["post_status"],
          postType: postResult["post_type"],
          blogId: postResult["blog_id"],
          blogUsername: postResult["blog_username"],
          blogAvatar: postResult["blog_avatar"],
          blogAvatarShape: postResult["blog_avatar_shape"],
          blogTitle: postResult["blog_title"],
          postTime: postResult["post_time"],
        );
      postsResults.add(post);
      }
      for (final Map<String, dynamic> tagResult in tags) {
        print(tagResult);
        final Tag tag = Tag(
          tagDescription: tagResult["tag_description"],
          tagImgUrl: tagResult["tag_image"],
          postsCount: tagResult["posts_count"],
        );
        tagsResults.add(tag);
      }
      for (final Map<String, dynamic> blogResult in blogs) {
        print(blogResult);
        final Blog blog = Blog(
          isPrimary: false,
          // don't care
          allowAsk: false,
          // don't care
          allowSubmission: false,
          // don't care
          avatarImageUrl: blogResult["avatar"]
              .toString()
              .isNotEmpty
              ? blogResult["avatar"].toString()
              : "https://i.pinimg.com/736x/89/90/48/899048ab0cc455154006fdb9676964b3.jpg",
          avatarShape: blogResult["avatar_shape"] ?? "circle",
          headerImage: blogResult["header_image"]
              .toString()
              .isNotEmpty
              ? blogResult["header_image"].toString()
              : "https://picsum.photos/200",
          blogDescription: blogResult["description"] ?? "",
          blogTitle: blogResult["title"] ?? "",
          blogId: blogResult["id"],
          username: blogResult["username"] ?? "",
        );
        blogResults.add(blog);




    }
  }
  final List<List<dynamic>> result=
  <List<dynamic>>[postsResults, tagsResults, blogResults];
  return result;
}


