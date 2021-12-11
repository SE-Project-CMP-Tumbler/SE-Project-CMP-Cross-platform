import "dart:convert";

import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";

/// the provider class of all blogs
class BlogsData with ChangeNotifier {
  /// list of all blogs that belongs to a single user
  List<Blog> userBlogs = <Blog>[];

  /// to indicate the current
  int currentBlog = 0;

  ///Returns loaded blogs.
  // ignore: non_constant_identifier_names
  Future<List<Blog>> get_Blogs() async {
    return userBlogs;
  }

  /// to get the index of the current blog
  int getCurrentBlogIndex() {
    return currentBlog;
  }

  /// to update the index of the current blog
  Future<void> updateCurrentBlogIndex(final int index) async {
    currentBlog = index;
    notifyListeners();
  }

  ///fetch posts through http get request.
  Future<void> fetchAndSetBlogs() async {
    // clear all blogs.
    userBlogs.clear();
    final dynamic res = await Api().getBlogs();

    //checking the status code of the received response.
    if (res.statusCode == 401)
      throw HttpException("You are not authorized");
    else if (res.statusCode == 404) {
      throw HttpException("Not Found!");
    } else if (res.statusCode == 500) {
      throw HttpException("Internal Server Error!");
    }

    final Map<String, dynamic> encodedRes = jsonDecode(res.body);

    //set _userBlogs list.
    final List<dynamic> blogsList = encodedRes["response"]["blogs"];
    for (int i = 0; i < blogsList.length; i++) {
      userBlogs.add(
        Blog(
          blogId: blogsList[i]["id"],
          isPrimary: blogsList[i]["is_primary"],
          username: blogsList[i]["username"],
          avatarImageUrl: blogsList[i]["avatar"],
          avatarShape: blogsList[i]["avatar_shape"],
          headerImage: blogsList[i]["header_image"],
          blogTitle: blogsList[i]["title"],
          allowAsk: blogsList[i]["allow_ask"],
          allowSubmission: blogsList[i]["allow_submittions"],
          blogDescription: blogsList[i]["description"],
        ),
      );
    }

    notifyListeners();
  }

  ///fetch posts through http get request.
  Future<void> addAndUpdateBlogs(final String blogUserName) async {
    // clear all blogs.
    final dynamic res = await Api().postNewBlog(blogUserName);
    final Map<String, dynamic> encodedRes = jsonDecode(res.body);
    //checking the status code of the received response.
    if (res.statusCode == 401)
      throw HttpException(encodedRes["meta"]["msg"]);
    else if (res.statusCode == 422) {
      throw HttpException(encodedRes["meta"]["msg"]);
    } else if (res.statusCode == 500) {
      throw HttpException(encodedRes["meta"]["msg"]);
    }
    await fetchAndSetBlogs();
  }
}
