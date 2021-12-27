
import "dart:convert";

import "package:http/http.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/post_model.dart";

/// a function that fetch all random posts and return list of posts
Future<List<PostModel>> getRandomPosts()async{
  List<PostModel> randomPosts=<PostModel>[];
  final dynamic res= await Api().fetchRandomPosts();
  final dynamic response= jsonDecode(res.body);
  final List<dynamic> posts = response["response"]["posts"];
  if (response["meta"]["status"] == "200") {
    randomPosts= await PostModel.fromJSON(posts, true);
  }
  return randomPosts;

}
