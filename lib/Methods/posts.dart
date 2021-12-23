// import "dart:convert";
//
// import "package:tumbler/Methods/api.dart";
// import "package:tumbler/Models/http_requests_exceptions.dart";
// import "package:tumbler/Models/notes.dart";
// import "package:tumbler/Models/post_model.dart";
//
// // ignore: avoid_classes_with_only_static_members
// ///Posts provider manage the state of posts.
// class Posts {
//   static final List<PostModel> _homePosts = <PostModel>[];
//   static final Map<int, Notes> _notes = <int, Notes>{};
//
//   ///Returns loaded posts.
//   static List<PostModel> get homePosts {
//     return <PostModel>[..._homePosts];
//   }
//
//   ///Getter : returns the notes of a certain post
//   static Notes getNotesForSinglePost(final int postID) {
//     return _notes[postID]!;
//   }
//
//
//
//   ///fetch posts through http get request.
//   static Future<void> fetchAndSetPosts() async {
//     // clear all loaded post.
//     _homePosts.clear();
//     final dynamic res = await Api().fetchHomePosts(1);
//
//     //checking the status code of the received response.
//     if (res.statusCode == 401)
//       throw HttpException("You are not authorized");
//     else if (res.statusCode == 404) {
//       throw HttpException("Not Found!");
//     }
//
//     final Map<String, dynamic> encodedRes = jsonDecode(res.body);
//
//     //set _homePost list.
//     final List<dynamic> postsList =
//         encodedRes["response"]["posts"]; // here i should remove .values.single
//
//     for (int i = 0; i < postsList.length; i++) {
//       _homePosts.add(
//         PostModel(
//           postId: postsList[i]["post_id"] as int,
//           postBody: postsList[i]["post_body"] ?? "",
//           postStatus: postsList[i]["post_status"] ?? "",
//           postType: postsList[i]["post_type"] ?? "",
//           blogId: postsList[i]["blog_id"] as int,
//           blogUsername: postsList[i]["blog_username"] ?? "",
//           blogAvatar: "",
//           blogAvatarShape: postsList[i]["blog_avatar_shape"] ?? "",
//           blogTitle: postsList[i]["blog_title"] ?? "",
//           postTime: postsList[i]["post_time"] ?? "", notes: 0,
//         ),
//       );
//     }
//
//     // setting the notes for each post in _homePosts through http requests.
//     for (int i = 0; i < _homePosts.length; i++) {
//       final Map<String, dynamic> recievedNotes =
//           await Api().getNotes(_homePosts[i].postId.toString());
//
//       //check the status code for the received response.
//       if (recievedNotes["meta"]["status"] == "404")
//         throw HttpException("Not Found!");
//       else {
//         final List<dynamic> likes =
//             recievedNotes["response"]["likes"] ?? <dynamic>[];
//         final List<dynamic> reblogs =
//             recievedNotes["response"]["reblogs"] ?? <dynamic>[];
//         final List<dynamic> replies =
//             recievedNotes["response"]["replies"] ?? <dynamic>[];
//
//         _notes[_homePosts[i].postId] =
//             Notes(likes: likes, reblogs: reblogs, replies: replies);
//       }
//     }
//   }
// }
