import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/blog.dart";

/// Inorder to follow a specific [Blog] with [blogId]
/// this function call the [Api] method [Api.followBlog]
///  and check the response status, if 200 it returns true,
///  means that the [User] successfully followed a [Blog],
///  otherwise, it returns false, meaning that the following was unsuccessful
Future<bool> followBlog(final int blogId,) async
{
  bool successful=false;
  final Map<String, dynamic> response= await Api().followBlog(blogId);
  if (response["meta"]["status"] == "200") {
    successful = true;
  }
  return successful;
}


/// Inorder to unfollow a specific [Blog] with [blogId]
/// this function call the [Api] method [Api.unfollowBlog]
///  and check the response status, if 200 it returns true,
///  means that the [User] successfully unfollow a [Blog],
///  otherwise, it returns false, meaning that the unfollow process
///  was unsuccessful

Future<bool> unFollowBlog(final int blogId,) async
{
  bool successful=false;
  final Map<String, dynamic> response= await Api().unFollowBlog(blogId);

  if (response["meta"]["status"] == "200") {
    successful = true;
  }
  return successful;
}
