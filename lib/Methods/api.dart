// ignore_for_file: prefer_interpolation_to_compose_strings

import "dart:convert";
import "dart:io" as io;

import "package:http/http.dart" as http;
import "package:tumbler/Models/user.dart";

/// Class [Api] is used for all GET, POST, PUT, Delete request from the backend.
class Api {
  static const String _host = "https://api.tumbler.social/api";
  static const String _firebaseHost =
      "https://mock-back-default-rtdb.firebaseio.com";
  final String _getTrendingTags = "/tag/trending";
  final String _signUp = "/register";
  final String _login = "/login";
  final String _forgotPassword = "/forgot_password";
  final String _uploadImage = "/upload_photo/";
  final String _uploadVideo = "/upload_video/";
  final String _uploadAudio = "/upload_audio/";
  final String _addPost = "/post/";
  final String _changeEmail = "/change_email";
  final String _changePass = "/change_password";
  final String _logOut = "/logout";

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
                         "msg": "Failed to connect to the server"
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
    // it need Authorization, why ??
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
  Future<Map<String, dynamic>> uploadVideo(final io.File video) async {
    final http.Response response = await http.post(
      Uri.parse(_host + _uploadVideo + User.userID),
      headers: <String, String>{
        "Authorization": User.accessToken,
      },
      body: <String, dynamic>{
        "video": video,
      },
    ).onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Upload [image] to our server to get url of this image.
  Future<Map<String, dynamic>> uploadImage(final io.File image) async {
    final http.Response response = await http.post(
      Uri.parse(_host + _uploadImage + User.userID),
      headers: <String, String>{
        "Authorization": User.accessToken,
      },
      body: <String, dynamic>{
        "image": image,
      },
    ).onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Upload [audio] to our server to get url of this audio.
  Future<Map<String, dynamic>> uploadAudio(final io.File audio) async {
    final http.Response response = await http.post(
      Uri.parse(_host + _uploadAudio + User.userID),
      headers: <String, String>{
        "Authorization": User.accessToken,
      },
      body: <String, dynamic>{
        "audio": audio,
      },
    ).onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// Upload HTML code of the post.
  Future<Map<String, dynamic>> addPost(
    final String postBody,
    final String postStatus,
    final String postType,
    final String postTime,
  ) async {
    final http.Response response = await http.post(
      Uri.parse(_host + _addPost + User.userID),
      headers: <String, String>{
        "Authorization": User.accessToken,
      },
      body: <String, String>{
        "post_status": postStatus,
        "post_time": postTime,
        "post_type": postType,
        "post_body": postBody
      },
    ).onError((final Object? error, final StackTrace stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  /// GET Posts For the Home Page
  Future<dynamic> fetchAndPosts() async {
    try {
      final http.Response response = await http.get(
        Uri.parse("https://api.tumbler.social/api/posts/random_posts/"),
        headers: <String, String>{"Authorization": User.accessToken},
      );

      return response;
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  /// GET Notes For the post with id [postID]
  Future<Map<String, dynamic>> getNotes(final String postID) async {
    final http.Response response = await http.get(
      Uri.parse(
        "$_firebaseHost/notes/$postID.json",
      ),
      headers: <String, String>{"Authorization": User.accessToken},
    );

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
}
