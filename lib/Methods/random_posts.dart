import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/post_model.dart";

/// a function that fetch all random posts and return list of posts
Future<List<PostModel>> getRandomPosts({
  final int page = 1,
}) async {
  List<PostModel> randomPosts = <PostModel>[];
  final Map<String, dynamic> response =
      await Api().fetchRandomPosts(page: page);
  if (response["meta"]["status"] == "200") {
    final List<dynamic> posts = response["response"]["posts"];
    randomPosts = await PostModel.fromJSON(posts);
  }
  return randomPosts;
}
