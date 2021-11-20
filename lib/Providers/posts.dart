import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tumbler/Models/user.dart';

import '../Models/http_requests_exceptions.dart';
import '../Models/post.dart';

///Posts provider manage the state of posts.
class Posts with ChangeNotifier {
  final List<Post> _homePosts = [];

  ///Returns loaded posts.
  List<Post> get homePosts {
    return [..._homePosts];
  }

  ///fetch posts through http get request.
  Future<void> fetchAndSetPosts() async {
    try {
      final response = await http.get(
          Uri.parse("https://mock-back-default-rtdb.firebaseio.com/radar.json"),
          headers: {'Authorization': User.accessToken});

      // clear all loaded post.
      _homePosts.clear();

      Map<String, dynamic> res = json.decode(response.body);

      //checking the status code of the received response.
      if (res.values.single['meta']['status'] == "401")
        throw HttpException("You are not authorized");
      else if (res.values.single['meta']['status'] == "404")
        throw HttpException("Not Found!");

      //set _homePost list.
      res.forEach((id, data) {
        List<dynamic> postsList = data['response']['posts'];
        for (var i = 0; i < postsList.length; i++) {
          _homePosts.add(Post(
            postId: postsList[i]['post_id'] as int,
            postBody: postsList[i]['post_body'] as String,
            postStatus: postsList[i]['post_status'] as String,
            postType: postsList[i]['post_type'] as String,
            blogId: postsList[i]['blog_id'] as int,
            blogUsername: postsList[i]['blog_username'] as String,
            blogAvatar: postsList[i]['blog_avatar'] as String,
            blogAvatarShape: postsList[i]['blog_avatar_shape'] as String,
            blogTitle: postsList[i]['blog_title'] as String,
            postTime: postsList[i]['post_time'] as String,
          ));
        }
      });

      // setting the notes for each post in _homePosts through http requests.
      for (int i = 0; i < _homePosts.length; i++) {
        final res = await http.get(
            Uri.parse(
                "https://mock-back-default-rtdb.firebaseio.com/notes/${_homePosts[i].postId}.json"),
            headers: {'Authorization': User.accessToken});

        final Map<String, dynamic> notes = json.decode(res.body);

        //check the status code for the received response.
        if (notes.values.single['meta']['status'] == "404")
          throw HttpException("Not Found!");

        _homePosts[i].likes = notes.values.single['response']['likes'];
        _homePosts[i].reblogs = notes.values.single['response']['reblogs'];
        _homePosts[i].replies = notes.values.single['response']['replies'];
      }

      notifyListeners();
    } catch (error) {
      throw HttpException("Something went wrong");
    }
  }
}
