import "package:tumbler/Methods/api.dart";

/// Inorder to follow a specific [Tag] with [tagDescription]
/// this function call the [Api] method [Api.followTag]
///  and check the response status, if 200 it returns true,
///  means that the [User] successfully followed a [Tag],
///  otherwise, it returns false, meaning that the follow process
///  was unsuccessful
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

/// Inorder to unfollow a specific [Tag] with [tagDescription]
/// this function call the [Api] method [Api.unFollowTag]
///  and check the response status, if 200 it returns true,
///  means that the [User] successfully unfollow a [Tag],
///  otherwise, it returns false, meaning that the unfollow process
///  was unsuccessful
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
