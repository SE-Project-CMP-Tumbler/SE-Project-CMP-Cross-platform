import "package:tumbler/Methods/api.dart";

/// inorder to follow a specific blog
/// returns true only if the response is "ok", otherwise it returns false
Future<bool> followBlog(
  final int blogId,
) async {
  bool successful = false;
  final Map<String, dynamic> response = await Api().followBlog(blogId);
  if (response["meta"]["status"] == "200") {
    successful = true;
  }

  return successful;
}

/// inorder to unfollow a specific blog
/// returns true only if the response is "ok", otherwise it returns false
Future<bool> unFollowBlog(
  final int blogId,
) async {
  bool successful = false;
  final Map<String, dynamic> response = await Api().unFollowBlog(blogId);

  if (response["meta"]["status"] == "200") {
    successful = true;
  }
  return successful;
}
