import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  static const String _host =
      "https://fff82fda-4df6-4c76-adb1-cba53e9e73f5.mock.pstmn.io";
  static const String _getTrendingTags = "/tag/trending";
  static const String _register = "/register";
  static const String _login = "/login";
  static const String _forgotPassword = "/login";

  Future<List<String>> getTrendingTags() async {
    http.Response response =
        await http.get(Uri.parse(_host + _getTrendingTags)).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response("{}", 404);
      },
    ).onError((error, stackTrace) => http.Response("{}", 404));

    List<String> result = [];
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)["response"]["tags"] as List<dynamic>;
      result.addAll(body.map((e) => e["tag_description"]));
    }

    return result;
  }

  Future<Map<String, dynamic>> register(
      String blogUsername, String password, String email, int age) async {
    http.Response response =
        await http.post(Uri.parse(_host + _register), body: {
      "email": email,
      "blog_username": blogUsername,
      "password": password,
      "age": age.toString()
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response("{}", 404);
      },
    ).onError((error, stackTrace) => http.Response("{}", 404));

    Map<String, dynamic> result = {};
    if (response.statusCode == 200)
      result = jsonDecode(response.body)["response"] as Map<String, dynamic>;

    return result;
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    http.Response response = await http.post(Uri.parse(_host + _login), body: {
      "email": email,
      "password": password,
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response("{}", 404);
      },
    ).onError((error, stackTrace) => http.Response("{}", 404));

    Map<String, dynamic> result = {};
    if (response.statusCode == 200)
      result = jsonDecode(response.body)["response"] as Map<String, dynamic>;

    return result;
  }

  Future<bool> forgetPassword(String email) async {
    http.Response response =
        await http.post(Uri.parse(_host + _forgotPassword), body: {
      "email": email,
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response("{}", 404);
      },
    ).onError((error, stackTrace) => http.Response("{}", 404));

    if (response.statusCode == 200) return true;

    return false;
  }
}
