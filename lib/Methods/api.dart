import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Api {
  final String mockHost = "http://10.0.2.2:3000/db";
  final String _getTrendingTags = "GET/tag/trending";

  Future<List<String>> getTrendingTags() async {
    http.Response response = await http
        .get(Uri.parse(mockHost))
        .timeout(const Duration(seconds: 10), onTimeout: () {
      Fluttertoast.showToast(
          msg: "Failed to get Trending",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return http.Response("", 404);
    });

    List<String> result = [];
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)["response"]["tags"] as List;
      result.addAll(body.map((e) => e["tag_description"]));
    }

    return result;
  }
}
