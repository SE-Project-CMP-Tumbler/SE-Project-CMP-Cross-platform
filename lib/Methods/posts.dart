import "dart:convert";


import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import "package:tumbler/Models/notes.dart";
import "package:tumbler/Models/post.dart";

// ignore: avoid_classes_with_only_static_members
///Posts provider manage the state of posts.
class Posts  {
  static List<Post> _homePosts = <Post>[];
  static  Map<int, Notes> _notes = <int, Notes>{};

  ///Returns loaded posts.
  static List<Post> get homePosts {
    return <Post>[..._homePosts];
  }

  ///Getter : returns the notes of a certain post
  static Notes getNotesForSinglePost(final int postID) {
    return _notes[postID]!;
  }

  /// Called when the user clicks on favorite icon button
  static Future<bool> likePost(final int postId) async {
    try {
      await Api().likePost(postId);

      final Map<String, dynamic> recievedNotes =
          await Api().getNotes(postId.toString());

      _notes[postId] = Notes(
        likes: recievedNotes["response"]["likes"],
        reblogs: recievedNotes["response"]["reblogs"],
        replies: recievedNotes["response"]["replies"],
      );
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }

    // if the prev request was successful make api().getNotes request
    // update notes of post with postId with data returned from api().getNotes
    // through _notes[postId] = Notes(................);

    // else return httpException
  }

  /// Called when the user clicks on un-favorite icon button (filled favorite)
  static Future<bool> unlikePost(final int postId) async {
    try {
      await Api().unlikePost(postId);

      final Map<String, dynamic> recievedNotes =
          await Api().getNotes(postId.toString());

      _notes[postId] = Notes(
        likes: recievedNotes["response"]["likes"],
        reblogs: recievedNotes["response"]["reblogs"],
        replies: recievedNotes["response"]["replies"],
      );
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
    // if the prev request was successful make api().getNotes request
    // update notes of post with postId with data returned from api().getNotes
    // through _notes[postId] = Notes(................);

    // else return httpException
  }

  ///fetch posts through http get request.
  static Future<void> fetchAndSetPosts() async {
    // clear all loaded post.
    _homePosts.clear();
    final dynamic res = await Api().fetchAndPosts();

    //checking the status code of the received response.
    if (res.statusCode == 401)
      throw HttpException("You are not authorized");
    else if (res.statusCode == 404) {
      throw HttpException("Not Found!");
    }

    final Map<String, dynamic> encodedRes = jsonDecode(res.body);

    //set _homePost list.
    final List<dynamic> postsList =
        encodedRes["response"]["posts"]; // here i should remove .values.single

    for (int i = 0; i < postsList.length; i++) {
      _homePosts.add(
        Post(
          postId: postsList[i]["post_id"] as int,
          postBody: postsList[i]["post_body"] ?? "",
          postStatus: postsList[i]["post_status"] ?? "",
          postType: postsList[i]["post_type"] ?? "",
          blogId: postsList[i]["blog_id"] as int,
          blogUsername: postsList[i]["blog_username"] ?? "",
          blogAvatar: "",
          blogAvatarShape: postsList[i]["blog_avatar_shape"] ?? "",
          blogTitle: postsList[i]["blog_title"] ?? "",
          postTime: postsList[i]["post_time"] ?? "",
        ),
      );
    }

    // setting the notes for each post in _homePosts through http requests.
    for (int i = 0; i < _homePosts.length; i++) {
      final Map<String, dynamic> recievedNotes =
          await Api().getNotes(_homePosts[i].postId.toString());

      //check the status code for the received response.
      if (recievedNotes["meta"]["status"] == "404")
        throw HttpException("Not Found!");
      else {
        final List<dynamic> likes =
            recievedNotes["response"]["likes"] ?? <dynamic>[];
        final List<dynamic> reblogs =
            recievedNotes["response"]["reblogs"] ?? <dynamic>[];
        final List<dynamic> replies =
            recievedNotes["response"]["replies"] ?? <dynamic>[];

        _notes[_homePosts[i].postId] =
            Notes(likes: likes, reblogs: reblogs, replies: replies);
      }
    }

  }
}
