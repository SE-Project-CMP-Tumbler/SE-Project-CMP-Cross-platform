import 'package:flutter/material.dart';

class Post with ChangeNotifier {
  String postId = " ";
  String postBody = "";
  String postStatus = "";
  String blogId = "";
  String blogUsername = "";
  String postYype = "";
  String blogAvatar = "";
  String blogAvatarShape = "";
  String blogTitle = "";
  String postTime = "";

  Post(
      {required this.postId,
      required this.postBody,
      required this.postStatus,
      required this.blogId,
      required this.blogUsername,
      required this.postYype,
      required this.blogAvatar,
      required this.blogAvatarShape,
      required this.blogTitle,
      required this.postTime});
}
