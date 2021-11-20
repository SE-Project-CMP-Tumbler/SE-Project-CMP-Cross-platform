import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:tumbler/Models/user.dart';

class Api {
  static const String _host =
      "https://fff82fda-4df6-4c76-adb1-cba53e9e73f5.mock.pstmn.io";
  final String _getTrendingTags = "/tag/trending";
  final String _signUp = "/register";
  final String _login = "/login";
  final String _forgotPassword = "/login";
  final String _uploadImage = "/upload_photo/";
  final String _uploadVideo = "/upload_video/";
  final String _uploadAudio = "/upload_audio/";
  final String _addPost = "/post/";

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
                         "msg": "Failed to get Trending"
                      }
            } 
        ''';

  Future<Map<String, dynamic>> getTrendingTags() async {
    // it need Authorization, why ??
    http.Response response = await http
        .get(Uri.parse(_host + _getTrendingTags))
        .onError((error, stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> signUp(
      String blogUsername, String password, String email, int age) async {
    http.Response response = await http.post(Uri.parse(_host + _signUp), body: {
      "email": email,
      "blog_username": blogUsername,
      "password": password,
      "age": age.toString(),
    }).onError((error, stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    http.Response response = await http.post(Uri.parse(_host + _login), body: {
      "email": email,
      "password": password,
    }).onError((error, stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> forgetPassword(String email) async {
    http.Response response =
        await http.post(Uri.parse(_host + _forgotPassword), body: {
      "email": email,
    }).onError((error, stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> uploadImage(io.File video) async {
    http.Response response = await http.post(
      Uri.parse(_host + _uploadVideo + User.id),
      headers: {
        'Authorization': User.accessToken,
      },
      body: {
        "video": video,
      },
    ).onError((error, stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> uploadVideo(io.File image) async {
    http.Response response = await http.post(
      Uri.parse(_host + _uploadImage + User.id),
      headers: {
        'Authorization': User.accessToken,
      },
      body: {
        "image": image,
      },
    ).onError((error, stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> uploadAudio(io.File audio) async {
    http.Response response = await http.post(
      Uri.parse(_host + _uploadAudio + User.id),
      headers: {
        'Authorization': User.accessToken,
      },
      body: {
        "video": audio,
      },
    ).onError((error, stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> addPost(String postBody, String postStatus,
      String postType, String postTime) async {
    http.Response response = await http.post(
      Uri.parse(_host + _addPost + User.id + ".json"),
      headers: {
        'Authorization': User.accessToken,
      },
      body: {
        'post_status': postStatus,
        'post_time': postTime,
        'post_type': postType,
        'post_body': postBody
      },
    ).onError((error, stackTrace) {
      if (error.toString().startsWith("SocketException: Failed host lookup")) {
        return http.Response(_weirdConnection, 502);
      } else {
        return http.Response(_failed, 404);
      }
    });

    return jsonDecode(response.body);
  }
}
