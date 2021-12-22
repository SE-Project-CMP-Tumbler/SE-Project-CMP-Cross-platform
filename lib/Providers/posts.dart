// import "dart:convert";
//
// import "package:flutter/material.dart";
// import "package:tumbler/Methods/api.dart";
// import 'package:tumbler/Methods/show_toast.dart';
// import "package:tumbler/Models/http_requests_exceptions.dart";
// import "package:tumbler/Models/post_model.dart";
//
// ///Posts provider manage the state of posts.
// class Posts with ChangeNotifier {
//   final List<Post> _homePosts = <Post>[];
//   final List<Post> _profilePosts = <Post>[];
//
//   ///Returns loaded posts.
//   List<Post> get homePosts {
//     return <Post>[..._homePosts];
//   }
//
//   /// Returns all profile 'Posts' tab
//   List<Post> get profilePosts {
//     return <Post>[..._profilePosts];
//   }
//
//   ///fetch posts through http get request.
//   Future<void> fetchAndSetPosts() async {
//     // clear all loaded post.
//     _homePosts.clear();
//     final Map<String, dynamic> response = await Api().fetchHomePosts(1);
//
//     //checking the status code of the received response.
//     if (response["meta"]["status"] == "200") {
//       //set _homePost list.
//       final List<dynamic> postsList = response["response"]["posts"];
//       for (int i = 0; i < postsList.length; i++) {
//         _homePosts.add(
//           Post(
//             postId: postsList[i]["post_id"] as int,
//             postBody: postsList[i]["post_body"] ?? "",
//             postStatus: postsList[i]["post_status"] ?? "",
//             postType: postsList[i]["post_type"] ?? "",
//             blogId: postsList[i]["blog_id"] as int,
//             blogUsername: postsList[i]["blog_username"] ?? "",
//             blogAvatar: "",
//             blogAvatarShape: postsList[i]["blog_avatar_shape"] ?? "",
//             blogTitle: postsList[i]["blog_title"] ?? "",
//             postTime: postsList[i]["post_time"] ?? "",
//           ),
//         );
//       }
//
//       // setting the notes for each post in _homePosts through http requests.
//       for (int i = 0; i < _homePosts.length; i++) {
//         final Map<String, dynamic> notes =
//             await Api().getNotes("${_homePosts[i].postId}");
//
//         //check the status code for the received response.
//         if (notes["meta"]["status"] == "200") {
//           _homePosts[i].likes = notes["response"]["likes"] ?? <dynamic>[];
//           _homePosts[i].reblogs = notes["response"]["reblogs"] ?? <dynamic>[];
//           _homePosts[i].replies = notes["response"]["replies"] ?? <dynamic>[];
//         } else {
//           await showToast(notes["meta"]["msg"]);
//           throw HttpException("Not Found!");
//         }
//       }
//       notifyListeners();
//     } else
//       await showToast(response["meta"]["msg"]);
//   }
//
//   ///fetch specific blog posts through http get request.
//   Future<void> fetchSpecificBlogPosts() async {
//     // clear all loaded post.
//     _profilePosts.clear();
//     final dynamic res = await Api().fetchSpecificBlogPost();
//     final Map<String, dynamic> encodedRes = jsonDecode(res.body);
//     //checking the status code of the received response.
//     if (res.statusCode == 401)
//       throw HttpException(encodedRes["meta"]["msg"]);
//     else if (res.statusCode == 403) {
//       throw HttpException(encodedRes["meta"]["msg"]);
//     } else if (res.statusCode == 404) {
//       throw HttpException(encodedRes["meta"]["msg"]);
//     }
//     //set _homePost list.
//     final List<dynamic> postsList = encodedRes["response"]["posts"];
//     for (int i = 0; i < postsList.length; i++) {
//       _profilePosts.add(
//         Post(
//           postId: postsList[i]["post_id"] as int,
//           postBody: postsList[i]["post_body"] ?? "",
//           postStatus: postsList[i]["post_status"] ?? "",
//           postType: postsList[i]["post_type"] ?? "",
//           blogId: postsList[i]["blog_id"] as int,
//           blogUsername: postsList[i]["blog_username"] ?? "",
//           blogAvatar: "",
//           blogAvatarShape: postsList[i]["blog_avatar_shape"] ?? "",
//           blogTitle: postsList[i]["blog_title"] ?? "",
//           postTime: postsList[i]["post_time"] ?? "",
//         ),
//       );
//     }
//
//     // setting the notes for each post in _homePosts through http requests.
//     for (int i = 0; i < _profilePosts.length; i++) {
//       final Map<String, dynamic> notes = await Api().getNotes("${i % 2 + 1}");
//
//       //check the status code for the received response.
//       if (notes.values.single["meta"]["status"] == "404")
//         throw HttpException("Not Found!");
//       else {
//         _profilePosts[i].likes =
//             notes.values.single["response"]["likes"] ?? <dynamic>[];
//         _profilePosts[i].reblogs =
//             notes.values.single["response"]["reblogs"] ?? <dynamic>[];
//         _profilePosts[i].replies =
//             notes.values.single["response"]["replies"] ?? <dynamic>[];
//       }
//     }
//
//     notifyListeners();
//   }
// }
