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
          "https://mock-back-default-rtdb.firebaseio.com/homePost.json"));

      Map<String, dynamic> loadedPosts = json.decode(response.body);
      loadedPosts.forEach((id, data) {
        _homePosts.add(Post(
            postId: id,
            isFavorite: data['isFavorite'],
            notesNum: data['notesNum'],
            postAvatar: data['postAvatar'],
            postBody: data['postBody'],
            postUserName: data['postUserName']));
      });

      print(_homePosts);
      notifyListeners();
    } on Exception catch (error) {
      print(error);
      throw error;
    }
  }
}
