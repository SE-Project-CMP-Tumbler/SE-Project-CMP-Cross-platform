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

  final String _getTrendingTags = dotenv.env["host"] ?? " ";
  final String _signUp          = dotenv.env["signUp"] ?? " ";
  final String _login           = dotenv.env["login"] ?? " ";
  final String _forgotPassword  = dotenv.env["forgotPassword"] ?? " ";
  final String _uploadImage     = dotenv.env["uploadImage"] ?? " ";
  final String _uploadVideo     = dotenv.env["uploadVideo"] ?? " ";
  final String _uploadAudio     = dotenv.env["uploadAudio"] ?? " ";
  final String _addPost         = dotenv.env["addPost"] ?? " ";
  final String _blog            = dotenv.env["blog"] ?? " ";
  final String _fetchPost       = dotenv.env["fetchPost"] ?? " ";
  final String _changeEmail     = dotenv.env["changeEmail"] ?? " ";
  final String _changePass      = dotenv.env["changePass"] ?? " ";
  final String _logOut          = dotenv.env["logOut"] ?? " ";

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
    ).onError((final Object? error, final StackTrace stackTrace) {
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
    final http.Response response = await http
        .post(
      Uri.parse(_host + _uploadVideo + User.userID),
      headers: <String, String>{
        "Authorization": User.accessToken,
        "Content-Type": "multipart/form-data",
      },
      body: json.encode(<String, dynamic>{
        "video": video,
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

  /// Upload [image] to our server to get url of this image.
  Future<dynamic> uploadImage(final io.File image) async {
    // var request =
    //     http.MultipartRequest('POST', Uri.parse(_host + _uploadImage));
    // request.headers.addAll({
    //   "Authorization": User.accessToken,
    //   "Content-Type": "multipart/form-data",
    // });
    // var mpf = image;
    // request.files.add(mpf);
    // var response = await request.send;

    // final http.Response response = await http
    //     .post(
    //   Uri.parse(_host + _uploadImage + User.id),
    //
    //   headers: <String, String>{
    //     "Authorization": User.accessToken,
    //     "Content-Type": "multipart/form-data",
    //   },
    //   body: image,
    // )
    // .onError((final Object? error, final StackTrace stackTrace) {
    //   if (error.toString()
    //   .startsWith("SocketException: Failed host lookup")) {
    //     return http.Response(_weirdConnection, 502);
    //   } else {
    //     return http.Response(_failed, 404);
    //   }
    // });
    // return response;
  }

  /// Upload [audio] to our server to get url of this audio.
  Future<Map<String, dynamic>> uploadAudio(final io.File audio) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _uploadAudio + User.userID),
      headers: <String, String>{
        "Authorization": "Bearer " + User.accessToken,
        "Content-Type": "multipart/form-data",
        //"Accept" :
      },
      body: json.encode(<String, dynamic>{
        "audio": audio,
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

  /// Upload HTML code of the post.
  Future<Map<String, dynamic>> addPost(
    //Future<void> addPost(
    final String postBody,
    final String postStatus,
    final String postType,
    final String postTime,
  ) async {
    final http.Response response = await http
        .post(
      Uri.parse(_host + _addPost + User.userID),
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
  Future<dynamic> fetchAndPosts() async {
    try {
      final http.Response response = await http.get(
        Uri.parse(_host + _fetchPost),
        headers: _headerContentAuth,
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  /// GET Notes For the post with [postID]
  Future<Map<String, dynamic>> getNotes(final String postID) async {
    final http.Response response = await http.get(
      Uri.parse(
        "$_firebaseHost/notes/$postID.json",
      ),
      headers: _headerContentAuth,
    );
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
