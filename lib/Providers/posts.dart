import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Models/post.dart';

class Posts with ChangeNotifier {
  List<Post> _homePosts = [];

  List<Post> get homePosts {
    return [..._homePosts];
  }

  Future<void> fetchAndSetPosts() async {
    try {
      final response = await http.get(Uri.parse(
          "https://mock-back-default-rtdb.firebaseio.com/radar.json"));

      _homePosts.clear();
      Map<String, dynamic> res = json.decode(response.body);
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
      print(_homePosts);
      for (int i = 0; i < _homePosts.length; i++) {
        final res = await http.get(Uri.parse(
            "https://mock-back-default-rtdb.firebaseio.com/notes/${_homePosts[i].postId}.json"));
        final Map<String, dynamic> notes = json.decode(res.body);

        _homePosts[i].likes = notes.values.single['response']['likes'];
        _homePosts[i].reblogs = notes.values.single['response']['reblogs'];
        _homePosts[i].replies = notes.values.single['response']['replies'];
      }

      print(_homePosts);
      notifyListeners();
    } on Exception catch (error) {
      print(error);
      throw error;
    }
  }
}
