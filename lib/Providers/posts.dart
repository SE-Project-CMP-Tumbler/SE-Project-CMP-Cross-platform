// ignore_for_file: always_specify_types

import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import "package:tumbler/Models/post.dart";

///Posts provider manage the state of posts.
class Posts with ChangeNotifier {
  final List<Post> _homePosts = <Post>[];

  ///Returns loaded posts.
  List<Post> get homePosts {
    return <Post>[..._homePosts];
  }

  ///fetch posts through http get request.
  Future<void> fetchAndSetPosts() async {
    // clear all loaded post.
    _homePosts.clear();
    final Map<String, dynamic> res = await Api().fetchAndPosts();

    //checking the status code of the received response.
    if (res.values.single["meta"]["status"] == "401")
      throw HttpException("You are not authorized");
    else if (res.values.single["meta"]["status"] == "404")
      throw HttpException("Not Found!");

    //set _homePost list.
    res.forEach((final String id, final dynamic data) {
      final List<dynamic> postsList = data["response"]["posts"];
      for (int i = 0; i < postsList.length; i++) {
        _homePosts.add(
          Post(
            postId: postsList[i]["post_id"] as int,
            postBody: postsList[i]["post_body"] as String,
            postStatus: postsList[i]["post_status"] as String,
            postType: postsList[i]["post_type"] as String,
            blogId: postsList[i]["blog_id"] as int,
            blogUsername: postsList[i]["blog_username"] as String,
            blogAvatar: postsList[i]["blog_avatar"] as String,
            blogAvatarShape: postsList[i]["blog_avatar_shape"] as String,
            blogTitle: postsList[i]["blog_title"] as String,
            postTime: postsList[i]["post_time"] as String,
          ),
        );
      }
    });

    // setting the notes for each post in _homePosts through http requests.
    for (int i = 0; i < _homePosts.length; i++) {
      final Map<String, dynamic> notes =
          await Api().getNotes(_homePosts[i].postId.toString());

      //check the status code for the received response.
      if (notes.values.single["meta"]["status"] == "404")
        throw HttpException("Not Found!");
      else {
        _homePosts[i].likes = notes.values.single["response"]["likes"] ?? [];
        _homePosts[i].reblogs =notes.values.single["response"]["reblogs"] ??[];
        _homePosts[i].replies = notes.values.single["response"]["replies"] ??[];
      }
    }

    notifyListeners();
  }
}
