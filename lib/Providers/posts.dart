import 'dart:convert';

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
    final dynamic res = await Api().fetchAndPosts();

    //checking the status code of the received response.
    if (res.statusCode == 401)
      throw HttpException("You are not authorized");
    else if (res.statusCode == 404) throw HttpException("Not Found!");

    final Map<String, dynamic> encodedRes = jsonDecode(res.body);

    //set _homePost list.
    final List<dynamic> postsList = encodedRes["response"]["posts"];
    for (int i = 0; i < postsList.length; i++) {
      _homePosts.add(
        Post(
          postId: postsList[i]["post_id"] as int,
          postBody: postsList[i]["post_body"] ?? "",
          postStatus: postsList[i]["post_status"] ?? "",
          postType: postsList[i]["post_type"] ?? "",
          blogId: postsList[i]["blog_id"] as int,
          blogUsername: postsList[i]["blog_username"] ?? "",
          blogAvatar: postsList[i]["blog_avatar"] ?? "",
          blogAvatarShape: postsList[i]["blog_avatar_shape"] ?? "",
          blogTitle: postsList[i]["blog_title"] ?? "",
          postTime: postsList[i]["post_time"] ?? "",
        ),
      );
    }

    // setting the notes for each post in _homePosts through http requests.
    for (int i = 0; i < _homePosts.length; i++) {
      final Map<String, dynamic> notes = await Api().getNotes("${i%2 + 1}");

      //check the status code for the received response.
      if (notes.values.single["meta"]["status"] == "404")
        throw HttpException("Not Found!");
      else {
        _homePosts[i].likes = notes.values.single["response"]["likes"] ?? [];
        _homePosts[i].reblogs =
            notes.values.single["response"]["reblogs"] ?? [];
        _homePosts[i].replies =
            notes.values.single["response"]["replies"] ?? [];
      }
    }

    notifyListeners();
  }
}
