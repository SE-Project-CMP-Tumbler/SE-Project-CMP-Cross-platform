
import "dart:convert";

import "package:http/http.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/post.dart";

/// a function that fetch all random posts and return list of posts
Future<List<Post>> getRandomPosts()async{
  final List<Post> randomPosts=<Post>[];
  final dynamic res= await Api().fetchRandomPosts();
  final dynamic response= jsonDecode(res.body);
  final List<dynamic> posts = response["response"]["posts"];
  if (response["meta"]["status"] == "200") {
    for (final  Map<String, dynamic> post in posts) {
      print(post.toString());
      final Post randomPost= Post(
          postId: post["post_id"],
          postBody: post["post_body"],
          postStatus: post["post_status"],
          postType: post["post_type"],
          blogId: post["blog_id"],
          blogUsername: post["blog_username"],
          blogAvatar: post["blog_avatar"],
          blogAvatarShape: post["blog_avatar_shape"],
          blogTitle: post["blog_title"],
          postTime: post["post_time"],
      );
      randomPosts.add(randomPost);
    }
  }
  return randomPosts;

}
