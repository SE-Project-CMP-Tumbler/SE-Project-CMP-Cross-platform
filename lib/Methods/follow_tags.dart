import "package:tumbler/Methods/api.dart";

/// inorder to follow a specific tag
/// returns true only if the response is "ok", otherwise it returns false
Future<bool> followTag(
  final String tagDescription,
) async {
  bool successful = false;
  final Map<String, dynamic> response = await Api().followTag(tagDescription);
  if (response["meta"]["status"] == "200") {
    successful = true;
  }

  return successful;
}

/// inorder to unfollow a specific tag
/// returns true only if the response is "ok", otherwise it returns false
Future<bool> unFollowTag(
  final String tagDescription,
) async {
  bool successful = false;
  final Map<String, dynamic> response = await Api().unFollowTag(tagDescription);

  if (response["meta"]["status"] == "200") {
    successful = true;
  }
  return successful;
}
