import "dart:convert";

import "package:http/http.dart";
import "package:tumbler/Methods/api.dart";

/// inorder to follow a specific tag
/// returns true only if the response is "ok", otherwise it returns false
Future<bool> followTag(final String tagDescription,) async
{
  bool successful=false;
  final Response res = await Api().followTag(tagDescription);
  final Map<String, dynamic> response= jsonDecode(res.body);
  if (response["meta"]["status"] == "200") {
    successful= true;
  }
  return successful;
}


/// inorder to unfollow a specific tag
/// returns true only if the response is "ok", otherwise it returns false
Future<bool> unFollowTag(final String tagDescription,) async
{
  bool successful=false;
  final Response res = await Api().unFollowTag(tagDescription);
  final Map<String, dynamic> response= jsonDecode(res.body);
  print("Delete follow\n$response");
  if (response["meta"]["status"] == "200") {
    successful= true;
  }
  return successful;
}

