// ignore_for_file: prefer_interpolation_to_compose_strings
import "dart:convert";
import "dart:io" as io;

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:tumbler/Models/user.dart";

/// Class [Api] is used for all GET, POST, PUT, Delete request from the backend.
class Api {
  static const String _firebaseHost =
      "https://mock-back-default-rtdb.firebaseio.com";

  final String _host = dotenv.env["host"] ?? " ";
  final String _getTrendingTags = dotenv.env["getTrendingTags"] ?? " ";
  final String _signUp = dotenv.env["signUp"] ?? " ";
  final String _signUpWithGoogle = dotenv.env["signUpWithGoogle"] ?? " ";
  final String _login = dotenv.env["login"] ?? " ";
  final String _loginWithGoogle = dotenv.env["loginWithGoogle"] ?? " ";
  final String _forgotPassword = dotenv.env["forgotPassword"] ?? " ";
  final String _uploadImage = dotenv.env["uploadImage"] ?? " ";
  final String _uploadVideo = dotenv.env["uploadVideo"] ?? " ";
  final String _uploadAudio = dotenv.env["uploadAudio"] ?? " ";
  final String _addPost = dotenv.env["addPost"] ?? " ";
  final String _blog = dotenv.env["blog"] ?? " ";
  final String _blogSettings = dotenv.env["blog_settings"] ?? " ";
  final String _blogsLikes = dotenv.env["blogsLikes"] ?? " ";
  final String _dashboard = dotenv.env["dashboard"] ?? " ";
  final String _changeEmail = dotenv.env["changeEmail"] ?? " ";
  final String _changePass = dotenv.env["changePass"] ?? " ";
  final String _logOut = dotenv.env["logOut"] ?? " ";
  final String _published = dotenv.env["published"] ?? " ";
  final String _draft = dotenv.env["draft"] ?? " ";
  final String _posts = dotenv.env["Post"] ?? " ";
  final String _postNotes = dotenv.env["postNotes"] ?? " ";
  final String _postLikeStatus = dotenv.env["postLikeStatus"] ?? " ";
  final String _followings = dotenv.env["followings"] ?? " ";
  final String _likePost = dotenv.env["likePost"] ?? " ";
  final String _replyPost = dotenv.env["replyPost"] ?? " ";
  final String _followBlog = dotenv.env["followBlog"] ?? " ";
  final String _reblog = dotenv.env["reblog"] ?? " ";
  final String _chats = dotenv.env["chats"] ?? " ";
  final String _weirdConnection = '''
            {
              "meta": {
                        "status": "502",
                         "msg": "Weird Connection. Try Again?"
                      }
            }
        ''';

  final String _failed = '''
            {
              "meta": {
                        "status": "404",
                         "msg": "Failed to Connect to the server"
                      }
            }
        ''';

  final Map<String, String> _headerContent = <String, String>{
    io.HttpHeaders.acceptHeader: "application/json",
    io.HttpHeaders.contentTypeHeader: "application/json",
  };
  final Map<String, String> _headerContentAuth = <String, String>{
    io.HttpHeaders.acceptHeader: "application/json",
    io.HttpHeaders.contentTypeHeader: "application/json",
    io.HttpHeaders.authorizationHeader: "Bearer " + User.accessToken,
  };

  /// Make GET Request to the API to get List of
  /// Trending tags.
  Future<Map<String, dynamic>> getTrendingTags() async {
    final http.Response response = await http
        .get(Uri.parse(_host + _getTrendingTags))
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Sign Up
  Future<Map<String, dynamic>> signUp(
    final String blogUsername,
    final String password,
    final String email,
    final int age,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _signUp),
      body: jsonEncode(<String, String>{
        "email": email,
        "blog_username": blogUsername,
        "password": password,
        "age": age.toString(),
      }),
      headers: _headerContent,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Sign Up with Google
  Future<Map<String, dynamic>> signUpWithGoogle(
    final String blogUsername,
    final String googleAccessToken,
    final int age,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _signUpWithGoogle),
      body: jsonEncode(<String, String>{
        "google_access_token": googleAccessToken,
        "blog_username": blogUsername,
        "age": age.toString(),
      }),
      headers: _headerContent,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Log In
  Future<Map<String, dynamic>> logIn(
    final String email,
    final String password,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _login),
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
      headers: _headerContent,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Log In With Google
  Future<Map<String, dynamic>> logInWithGoogle(
    final String googleAccessToken,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _loginWithGoogle),
      body: jsonEncode(<String, String>{
        "google_access_token": googleAccessToken,
      }),
      headers: _headerContent,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Send Forget Password Email.
  Future<Map<String, dynamic>> forgetPassword(final String email) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _forgotPassword),
      body: jsonEncode(<String, String>{
        "email": email,
      }),
      headers: _headerContent,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Upload [video] to our server to get url of this video.
  Future<Map<String, dynamic>> uploadVideo(final String video) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _uploadVideo),
      headers: _headerContentAuth,
      body: json.encode(<String, String>{
        "b64_video": video,
      }),
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }


  ///get chats for that chats choose
  Future<dynamic> getChats() async {
    final http.Response response = await http
        .get(
      Uri.parse(_host + _chats),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return response;
  }


  /// Upload [image] to our server to get url of this image.
  Future<dynamic> uploadImage(final String image) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _uploadImage),
      headers: _headerContentAuth,
      body: json.encode(<String, String>{
        "b64_image": image,
      }),
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Upload [audio] to our server to get url of this audio.
  Future<Map<String, dynamic>> uploadAudio(final String audio) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _uploadAudio),
      headers: _headerContentAuth,
      body: json.encode(<String, String>{
        "b64_audio": audio,
      }),
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Get all blogs of user
  Future<Map<String, dynamic>> getAllBlogs() async {
    final http.Response response = await http.get(
      Uri.parse(_host + _blog),
      headers: _headerContentAuth,
    );
    return jsonDecode(response.body);
  }

  /// Upload HTML code of the post.
  Future<Map<String, dynamic>> addPost(
    final String postBody,
    final String postStatus,
    final String postType,
    final String postTime,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _addPost + User.blogsIDs[User.currentProfile]),
      headers: _headerContentAuth,
      body: jsonEncode(<String, String>{
        "post_status": postStatus,
        "post_time": postTime,
        "post_type": postType,
        "post_body": postBody
      }),
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// GET Posts For the Home Page
  Future<Map<String, dynamic>> fetchHomePosts(final int page) async {
    final http.Response response = await http
        .get(
      Uri.parse(_host + _dashboard + "?page=$page"),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// GET Notes For the post with id [postID]
  Future<Map<String, dynamic>> getNotes(final String postID) async {
    final http.Response response = await http
        .get(
      Uri.parse(_host + _postNotes + postID),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// GET getPostLikeStatus for a post with id [postID]
  Future<Map<String, dynamic>> getPostLikeStatus(final int postID) async {
    final http.Response response = await http
        .get(
      Uri.parse(
        _host + _postLikeStatus + User.blogsIDs[0] + "/" + postID.toString(),
      ),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// To make Like on Post
  Future<Map<String, dynamic>> likePost(final int postId) async {
    final http.Response response = await http
        .post(
      Uri.parse(
        _host + _likePost + postId.toString(),
      ),
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// To Make Unlike on post
  Future<Map<String, dynamic>> unlikePost(final int postId) async {
    final http.Response response = await http
        .delete(
      Uri.parse(
        _host + _likePost + postId.toString(),
      ),
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  ///Sends a post request to reply on a post.
  Future<Map<String, dynamic>> replyOnPost(
    final String postId,
    final String text,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(
        _host + _replyPost + postId,
      ),
      body: jsonEncode(<String, String>{
        "reply_text": text,
      }),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  ///Sends a post request to follow a blog.
  Future<Map<String, dynamic>> followBlog(
    final String blogId,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(
        _host + _followBlog + blogId,
      ),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  ///Sends a post request to unfollow a blog.
  Future<Map<String, dynamic>> unfollowBlog(
    final String blogId,
  ) async {
    final http.Response response = await http
        .delete(
      Uri.parse(
        _host + _followBlog + blogId,
      ),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  ///Get notifications for activity page.
  Future<Map<String, dynamic>> getActivityNotifications(
    final String blogId,
  ) async {
    final http.Response response = await http
        .get(
      Uri.parse(
        _host + _blog + "/" + blogId + "/notifications",
      ),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return <String, dynamic>{
      // ignore: always_specify_types
      "meta": {"status": "200", "msg": "ok"},
      // ignore: always_specify_types
      "response": {
        // ignore: always_specify_types
        "notifications": {
          // ignore: always_specify_types
          "answers": [
            // ignore: always_specify_types
            {
              "blog_avatar":
                  "https://cdnb.artstation.com/p/assets/images/images/043/022/785/large/giovani-kososki-joao-close-face.jpg?1636070573",
              "blog_avatar_shape": "circle",
              "blog_username": "radwa-ahmed213",
              "blog_title": "Positive Quotes",
              "blog_id": 1032,
              "answer_time": "2021-05-05 00:11",
              "post_id": 5,
              "post_body":
                  "<div><h1>What's Artificial intellegence? </h1><img src='https://modo3.com/thumbs/fit630x300/84738/1453981470/%D8%A8%D8%AD%D8%AB_%D8%B9%D9%86_Google.jpg' alt=''><p>It's the weapon that'd end the humanity!!</p><video width='320' height='240' controls><source src='movie.mp4' type='video/mp4'><source src='movie.ogg' type='video/ogg'>Your browser does not support the video tag.</video><p>#AI #humanity #freedom</p></div>",
              "post_type": "text"
            }
          ],
          // ignore: always_specify_types
          "reblogs": [
            // ignore: always_specify_types
            {
              "blog_avatar":
                  "https://cdnb.artstation.com/p/assets/images/images/043/022/785/large/giovani-kososki-joao-close-face.jpg?1636070573",
              "blog_avatar_shape": "circle",
              "blog_username": "radwa-ahmed213",
              "blog_title": "Positive Quotes",
              "blog_id": 1032,
              "post_time": "2021-08-12 00:23",
              "post_id": 5,
              "post_body":
                  "<div><h1>What's Artificial intellegence? </h1><img src='https://modo3.com/thumbs/fit630x300/84738/1453981470/%D8%A8%D8%AD%D8%AB_%D8%B9%D9%86_Google.jpg' alt=''><p>It's the weapon that'd end the humanity!!</p><video width='320' height='240' controls><source src='movie.mp4' type='video/mp4'><source src='movie.ogg' type='video/ogg'>Your browser does not support the video tag.</video><p>#AI #humanity #freedom</p></div>",
              "post_type": "text"
            }
          ],
          // ignore: always_specify_types
          "asks": [
            // ignore: always_specify_types
            {
              "question_body": "How are you?",
              "question_id": 5,
              "flag": false,
              "ask_time": "2021-09-05 00:22",
              "blog_avatar":
                  "https://cdnb.artstation.com/p/assets/images/images/043/022/785/large/giovani-kososki-joao-close-face.jpg?1636070573",
              "blog_avatar_shape": "circle",
              "blog_username": "radwa-ahmed213",
              "blog_id": 1032
            }
          ],
          // ignore: always_specify_types
          "follows": [
            // ignore: always_specify_types
            {
              "follow_time": "2021-08-12 00:17",
              "blog_avatar":
                  "https://cdnb.artstation.com/p/assets/images/images/043/022/785/large/giovani-kososki-joao-close-face.jpg?1636070573",
              "blog_avatar_shape": "circle",
              "blog_username": "radwa-ahmed213",
              "blog_id": 1032
            }
          ],
          // ignore: always_specify_types
          "mentions_posts": [
            // ignore: always_specify_types
            {
              "mention_time": "2021-07-15 00:19",
              "blog_avatar_mentioning": "/storage/imgname2.extension",
              "blog_avatar_shape_mentioning": "circle",
              "blog_username_mentioning": "radwa-ahmed213",
              "blog_id_mentioning": 1032,
              "blog_avatar":
                  "https://cdnb.artstation.com/p/assets/images/images/043/022/785/large/giovani-kososki-joao-close-face.jpg?1636070573",
              "blog_avatar_shape": "circle",
              "blog_username": "radwa-ahmed213",
              "blog_id": 1032,
              "post_id": 5,
              "post_body":
                  "<div><h1>What's Artificial intellegence? </h1><img src='https://modo3.com/thumbs/fit630x300/84738/1453981470/%D8%A8%D8%AD%D8%AB_%D8%B9%D9%86_Google.jpg' alt=''><p>It's the weapon that'd end the humanity!!</p><video width='320' height='240' controls><source src='movie.mp4' type='video/mp4'><source src='movie.ogg' type='video/ogg'>Your browser does not support the video tag.</video><p>#AI #humanity #freedom</p></div>",
              "post_type ": "text"
            }
          ],
          // ignore: always_specify_types
          "mentions_replies": [
            // ignore: always_specify_types
            {
              "mention_time": "2021-02-20 00:21",
              "blog_avatar_mentioning": "/storage/imgname2.extension",
              "blog_avatar_shape_mentioning": "circle",
              "blog_username_mentioning": "radwa-ahmed213",
              "blog_id_mentioning": 1032,
              "blog_avatar":
                  "https://cdnb.artstation.com/p/assets/images/images/043/022/785/large/giovani-kososki-joao-close-face.jpg?1636070573",
              "blog_avatar_shape": "circle",
              "blog_username": "radwa-ahmed213",
              "blog_id": 1032,
              "reply_id": 5,
              "reply_text": "Hello "
            }
          ]
        }
      }
    };
    //return jsonDecode(response.body);
  }

  /// Upload HTML code of the reblog.
  Future<Map<String, dynamic>> reblog(
    final String blogId,
    final String parentPostId,
    final String postBody,
    final String postStatus,
    final String postType,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _reblog + blogId + "/" + parentPostId),
      headers: _headerContentAuth,
      body: jsonEncode(<String, String>{
        "post_status": postStatus,
        "post_type": postType,
        "post_body": postBody
      }),
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  /// PUT request to change the current user Email
  /// with [email]
  Future<Map<String, dynamic>> changeEmail(
    final String email,
    final String password,
  ) async {
    final http.Response response = await http
        .put(
      Uri.parse(_host + _changeEmail),
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// PUT request to change the current user Password
  /// with [email]
  Future<Map<String, dynamic>> changePassword(
    final String currentPass,
    final String newPass,
    final String confirmPass,
  ) async {
    final http.Response response = await http
        .put(
      Uri.parse(_host + _changePass),
      body: jsonEncode(<String, String>{
        "current_password": currentPass,
        "password": newPass,
        "password_confirmation": newPass,
      }),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Post request to log out
  Future<Map<String, dynamic>> logOut() async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _logOut),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// blogs
  /// Make GET Request to the API to get List of all blogs (Profiles).
  Future<dynamic> getBlogs() async {
    final http.Response response = await http
        .get(
      Uri.parse(_host + _blog),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return response;
  }

  /// Post a new blog
  Future<dynamic> postNewBlog(
    final String blogUserName,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _blog),
      headers: _headerContentAuth,
      body: jsonEncode(<String, String>{
        "title": "Untitled",
        "blog_username": blogUserName,
      }),
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return response;
  }

  /// to get the Information of a specific blog
  Future<Map<String, dynamic>> getBlogInformation(
    final String blogID,
  ) async {
    final http.Response response = await http
        .get(
      Uri.parse(
        _host + _blog + "/" + blogID,
      ),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// to get the Settings of a specific blog
  Future<Map<String, dynamic>> getBlogSetting(
    final String blogID,
  ) async {
    final http.Response response = await http
        .get(
      Uri.parse(
        _host + _blogSettings + blogID,
      ),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// to get the posts of a specific blog
  Future<Map<String, dynamic>> fetchSpecificBlogPost(
    final String blogID,
    final int page,
  ) async {
    final http.Response response = await http
        .get(
      Uri.parse(
        _host + _posts + blogID + _published + "?page=$page",
      ),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// to get the Liked Posts of a My blog
  Future<Map<String, dynamic>> fetchLikedPost(final int page) async {
    final http.Response response = await http
        .get(
      Uri.parse(
        _host +
            _blogsLikes +
            User.blogsIDs[User.currentProfile] +
            "?page=$page",
      ),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// to get the Following of a specific blog
  Future<Map<String, dynamic>> fetchFollowings(final int page) async {
    final http.Response response = await http
        .get(
      Uri.parse(_host + _followings + "?page=$page"),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// to get the draft posts of a specific blog
  Future<Map<String, dynamic>> fetchDraftPost() async {
    final http.Response response = await http
        .get(
      Uri.parse(_host + _posts + User.blogsIDs[User.currentProfile] + _draft),
      headers: _headerContentAuth,
    )
        .onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }
}
