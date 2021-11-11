import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  final String mockHost = "http://10.0.2.2:3000/db";
  final String _getTrendingTags = "GET/tag/trending";

  Future<List<String>> getTrendingTags() async {
    http.Response response = await http.get(Uri.parse(mockHost));

    List<String> result = [];
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (var item in body["response"]["tags"])
        result.add(item["tag_description"]);
    }

    return result;
  }
}
