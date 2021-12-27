import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/post_model.dart";

/// a function that fetch all random posts and return list of posts
Future<List<PostModel>> getRandomPosts() async {
  List<PostModel> randomPosts = <PostModel>[];
  final Map<String, dynamic> response = await Api().fetchRandomPosts();
  if (response["meta"]["status"] == "200") {
    final List<dynamic> posts = response["response"]["posts"];
    randomPosts = await PostModel.fromJSON(posts, true);
  }
  return randomPosts;
}
