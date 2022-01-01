import "dart:convert";
import "dart:io" as io;

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/blog_theme.dart";
import "package:tumbler/Models/chat.dart";
import "package:tumbler/Models/message.dart";
import "package:tumbler/Models/notes.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/ActivityAndChat/acitivity_chat_screen.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";
import "package:tumbler/Screens/Search/manage_tags.dart";
import "package:tumbler/Screens/Search/recommended_posts.dart";
import "package:tumbler/Screens/Search/search_page.dart";
import "package:tumbler/Screens/Search/search_query.dart";
import "package:tumbler/Screens/Search/search_result.dart";
import "package:tumbler/Screens/Search/tag_posts.dart";
import "package:tumbler/Screens/Settings/profile_settings.dart";

/// Class [Api] is used for all GET, POST, PUT, Delete request from the backend.
/// All of its methods returns the JsonDecoded response of the http request
class Api {
  final String _host = dotenv.env["host"] ?? " ";
  final String _getTrendingTags = dotenv.env["getTrendingTags"] ?? " ";
  final String _signUp = dotenv.env["signUp"] ?? " ";
  final String _signUpWithGoogle = dotenv.env["signUpWithGoogle"] ?? " ";
  final String _login = dotenv.env["login"] ?? " ";
  final String _loginWithGoogle = dotenv.env["loginWithGoogle"] ?? " ";
  final String _forgotPassword = dotenv.env["forgotPassword"] ?? " ";
  final String _uploadImage = dotenv.env["uploadImage"] ?? " ";
  final String _uploadVideo = dotenv.env["uploadVideo"] ?? " ";
  final String _uploadAudio = dotenv.env["uploadAudio"] ?? " ";
  final String _post = dotenv.env["Post"] ?? " ";
  final String _blog = dotenv.env["blog"] ?? " ";
  final String _blogSettings = dotenv.env["blog_settings"] ?? " ";
  final String _blogsLikes = dotenv.env["blogsLikes"] ?? " ";
  final String _dashboard = dotenv.env["dashboard"] ?? " ";
  final String _changeEmail = dotenv.env["changeEmail"] ?? " ";
  final String _changePass = dotenv.env["changePass"] ?? " ";
  final String _logOut = dotenv.env["logOut"] ?? " ";
  final String _published = dotenv.env["published"] ?? " ";
  final String _draft = dotenv.env["draft"] ?? " ";
  final String _posts = dotenv.env["Posts"] ?? " ";
  final String _followedTags = dotenv.env["follow_tag"] ?? " ";
  final String _checkOutBlogs = dotenv.env["checkOutBlogs"] ?? " ";
  final String _randomPosts = dotenv.env["randomPosts"] ?? "";
  final String _checkOutTags = dotenv.env["checkOutTags"] ?? "";
  final String _tagPosts = dotenv.env["tagPosts"] ?? "";
  final String _topPosts = dotenv.env["topPosts"] ?? "";
  final String _recentPosts = dotenv.env["recentPosts"] ?? "";
  final String _autoComplete = dotenv.env["searchAutoComplete"] ?? "";
  final String _search = dotenv.env["search"] ?? "";
  final String _postNotes = dotenv.env["postNotes"] ?? " ";
  final String _postLikeStatus = dotenv.env["postLikeStatus"] ?? " ";
  final String _followings = dotenv.env["followings"] ?? " ";
  final String _likePost = dotenv.env["likePost"] ?? " ";
  final String _replyPost = dotenv.env["replyPost"] ?? " ";
  final String _reblog = dotenv.env["reblog"] ?? " ";
  final String _chats = dotenv.env["chats"] ?? " ";
  final String _chatRoom = dotenv.env["chatRoom"] ?? " ";
  final String _chatMessages = dotenv.env["chatMessages"] ?? " ";
  final String _sendMessage = dotenv.env["sendMessage"] ?? " ";
  final String _followBlog = dotenv.env["follow_blog"] ?? " ";
  final String _followTag = dotenv.env["follow_tag"] ?? " ";
  final String _tagData = dotenv.env["tagData"] ?? " ";
  final String _info = dotenv.env["info"] ?? " ";
  final String _theme = dotenv.env["theme"] ?? " ";
  final String _pin = dotenv.env["pin"] ?? " ";
  final String _unpin = dotenv.env["unpin"] ?? " ";
  final String _changeStatus = dotenv.env["changeStatus"] ?? " ";
  final String _followers = dotenv.env["followers"] ?? " ";

  final String _weirdConnection = '''
            {
              "meta": {
                        "status": "502",
                         "msg": "Weird Connection. Try Again?"
                      }
            }
        ''';

  final String _failed = '''
            {
              "meta": {
                        "status": "404",
                         "msg": "Failed to Connect to the server"
                      }
            }
        ''';
  final Map<String, String> _headerContent = <String, String>{
    io.HttpHeaders.acceptHeader: "application/json",
    io.HttpHeaders.contentTypeHeader: "application/json",
  };
  final Map<String, String> _headerContentAuth = <String, String>{
    io.HttpHeaders.acceptHeader: "application/json",
    io.HttpHeaders.contentTypeHeader: "application/json",
    io.HttpHeaders.authorizationHeader: "Bearer " + User.accessToken,
  };

  /// When an error occur with any [Api] request
  http.Response errorFunction(
    final Object? error,
    final StackTrace stackTrace,
  ) {
    if (error.toString().startsWith("SocketException: Failed host lookup")) {
      return http.Response(_weirdConnection, 502);
    } else {
      return http.Response(_failed, 404);
    }
  }

  /// THIS WILL BE OVERRIDDEN WHILE DOING TESTING WITH A MOCK-CLIENT.
  http.Client client = http.Client();

  /// Make GET Request to the [Api] to get List of Trending [Tag]s.
  Future<Map<String, dynamic>> getTrendingTags() async {
    final http.Response response = await client
        .get(Uri.parse(_host + _getTrendingTags))
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Make Post Request to the [Api] to Sign Up
  Future<Map<String, dynamic>> signUp(
    final String blogUsername,
    final String password,
    final String email,
    final int age,
  ) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _signUp),
          body: jsonEncode(<String, String>{
            "email": email,
            "blog_username": blogUsername,
            "password": password,
            "age": age.toString(),
          }),
          headers: _headerContent,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// GET current [User] followers, to display it from [ProfileSettings] page
  Future<Map<String, dynamic>> getFollowers() async {
    final http.Response response = await client
        .get(
          Uri.parse(
            _host + _followers,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Make Post Request to the [Api] to Sign Up with Google
  Future<Map<String, dynamic>> signUpWithGoogle(
    final String blogUsername,
    final String googleAccessToken,
    final int age,
  ) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _signUpWithGoogle),
          body: jsonEncode(<String, String>{
            "google_access_token": googleAccessToken,
            "blog_username": blogUsername,
            "age": age.toString(),
          }),
          headers: _headerContent,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Make Post Request to the [Api] to Log In
  Future<Map<String, dynamic>> logIn(
    final String email,
    final String password,
  ) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _login),
          body: jsonEncode(<String, String>{
            "email": email,
            "password": password,
          }),
          headers: _headerContent,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Make Post Request to the [Api] to Log In With Google
  Future<Map<String, dynamic>> logInWithGoogle(
    final String googleAccessToken,
  ) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _loginWithGoogle),
          body: jsonEncode(<String, String>{
            "google_access_token": googleAccessToken,
          }),
          headers: _headerContent,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Make Post Request to the [Api] to Send Forget Password Email.
  Future<Map<String, dynamic>> forgetPassword(final String email) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _forgotPassword),
          body: jsonEncode(<String, String>{
            "email": email,
          }),
          headers: _headerContent,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Upload [video] to our server to get url of this video.
  Future<Map<String, dynamic>> uploadVideo(final String video) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _uploadVideo),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "b64_video": video,
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  ///Get [Chat]s for that  [Chat]s choose of this [blogId]
  Future<Map<String, dynamic>> getChats(final String blogId) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _chats),
          headers: _headerContentAuth,
          body: json.encode(
            <String, String>{
              "from_blog_id": User.blogsIDs[User.currentProfile],
            },
          ),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Get chat [Message]s
  Future<Map<String, dynamic>> getMessages(final String roomId) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _chatMessages + roomId),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "from_blog_id": User.blogsIDs[User.currentProfile],
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Send [Message]s to a specific [roomId]
  /// with a message [text] and [photo]
  Future<Map<String, dynamic>> sendMessages(
    final String text,
    final String photo,
    final String roomId,
  ) async {
    dynamic dt = <String, String>{"text": text};
    if (photo != "") {
      dt = <String, String>{"photo": photo};
    }
    final http.Response response = await client
        .post(
          Uri.parse(_host + _sendMessage + roomId),
          headers: _headerContentAuth,
          body: json.encode(dt),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Get room id for chat, the http request body contains:
  /// the [User] blogId, and the [toBlogId] that the user wants to chat with
  Future<Map<String, dynamic>> getRoomId(final String toBlogId) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _chatRoom),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "from_blog_id": User.blogsIDs[User.currentProfile],
            "to_blog_id": toBlogId,
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Upload [image] to our server to get url of this [image].
  Future<Map<String, dynamic>> uploadImage(final String image) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _uploadImage),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "b64_image": image,
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Upload [audio] to our server to get url of this [audio].
  Future<Map<String, dynamic>> uploadAudio(final String audio) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _uploadAudio),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "b64_audio": audio,
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Get all personal [Blog]s of the current [User]
  Future<Map<String, dynamic>> getAllBlogs() async {
    final http.Response response = await client
        .get(
          Uri.parse(_host + _blog),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Upload HTML code of the [PostModel]
  /// body of the HTML request:
  /// takes [postBody] -> html of the body
  /// [postStatus] to indicate the post status
  /// [postType] to indicate the post type e.g, image
  /// [postTime] the dateTime when the post was published
  /// [blogId] the id of the blog that published this post
  Future<Map<String, dynamic>> addPost(
    final String postBody,
    final String postStatus,
    final String postType,
    final String postTime,
    final String blogId,
  ) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _post + blogId),
          headers: _headerContentAuth,
          body: jsonEncode(<String, String>{
            "post_status": postStatus,
            "post_time": postTime,
            "post_type": postType,
            "post_body": postBody
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Edit [PostModel] with an id [postID]
  Future<Map<String, dynamic>> editPost(
    final String postID,
    final String postStatus,
    final String postType,
    final String postBody,
  ) async {
    final http.Response response = await http
        .put(
          Uri.parse(_host + _post + postID),
          headers: _headerContentAuth,
          body: jsonEncode(<String, dynamic>{
            "post_status": postStatus,
            "post_type": postType,
            "post_body": postBody,
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Delete [PostModel] with an id [postID]
  Future<Map<String, dynamic>> deletePost(
    final String postID,
  ) async {
    final http.Response response = await http
        .delete(
          Uri.parse(_host + _post + postID),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Change status of [PostModel], if liked, commented on, etc.
  Future<Map<String, dynamic>> changePostStatus(
    final String postID,
    final String blogID,
  ) async {
    final http.Response response = await http
        .put(
          Uri.parse(_host + _posts + _changeStatus),
          body: jsonEncode(
            <String, String>{
              "blog_id": blogID,
              "post_id": postID,
              "post_status": "published",
            },
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Get the [PostModel] of a post with id [postID]
  Future<Map<String, dynamic>> getPost(
    final String postID,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(_host + _post + postID),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Pin a [PostModel].
  Future<Map<String, dynamic>> pinPost(
    final String postID,
    final String blogID,
  ) async {
    final http.Response response = await http
        .put(
          Uri.parse(_host + _posts + _pin),
          headers: _headerContentAuth,
          body: jsonEncode(<String, dynamic>{
            "blog_id": blogID,
            "post_id": postID,
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Unpin a [PostModel].
  Future<Map<String, dynamic>> unPinPost(
    final String postID,
    final String blogID,
  ) async {
    final http.Response response = await http
        .put(
          Uri.parse(_host + _posts + _unpin),
          headers: _headerContentAuth,
          body: jsonEncode(<String, dynamic>{
            "blog_id": blogID,
            "post_id": postID,
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// GET [PostModel]s For the [HomePage]
  Future<Map<String, dynamic>> fetchHomePosts(final int page) async {
    final http.Response response = await client
        .get(
          Uri.parse(_host + _dashboard + "?page=$page"),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// GET [Notes] For the [PostModel] with id [postID]
  Future<Map<String, dynamic>> getNotes(final String postID) async {
    final http.Response response = await client
        .get(
          Uri.parse(_host + _postNotes + postID),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// GET the status of liking a [PostModel] for an id [postID]
  Future<Map<String, dynamic>> getPostLikeStatus(final int postID) async {
    final http.Response response = await client
        .get(
          Uri.parse(
            _host +
                _postLikeStatus +
                User.blogsIDs[0] +
                "/" +
                postID.toString(),
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// POST request to like a [PostModel] using its [postId]
  Future<Map<String, dynamic>> likePost(final int postId) async {
    final http.Response response = await client
        .post(
          Uri.parse(
            _host + _likePost + postId.toString(),
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// DELETE request to unlike a [PostModel] using its [postId]
  Future<Map<String, dynamic>> unlikePost(final int postId) async {
    final http.Response response = await client
        .delete(
          Uri.parse(
            _host + _likePost + postId.toString(),
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Sends a post request to reply on a [PostModel] using its [postId]
  /// takes the [text] of the comment
  Future<Map<String, dynamic>> replyOnPost(
    final String postId,
    final String text,
  ) async {
    final http.Response response = await client
        .post(
          Uri.parse(
            _host + _post + _replyPost + postId,
          ),
          body: jsonEncode(<String, String>{
            "reply_text": text,
          }),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Sends a post request to unfollow a [Blog]
  Future<Map<String, dynamic>> unfollowBlog(
    final String blogId,
  ) async {
    final http.Response response = await client
        .delete(
          Uri.parse(
            _host + _followBlog + blogId,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Get notifications for [ActivityAndChatScreen]
  Future<Map<String, dynamic>> getActivityNotifications(
    final String blogId,
  ) async {
    final http.Response response = await client
        .get(
          Uri.parse(
            _host + "/notifications?type=all&for_blog_id=" + blogId,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Upload HTML code of the [reblog].
  Future<Map<String, dynamic>> reblog(
    final String blogId,
    final String parentPostId,
    final String postBody,
    final String postStatus,
    final String postType,
  ) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _reblog + blogId + "/" + parentPostId),
          headers: _headerContentAuth,
          body: jsonEncode(<String, String>{
            "post_status": postStatus,
            "post_type": postType,
            "post_body": postBody
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// PUT request to change the user [email]
  /// with his [password] to confirm
  Future<Map<String, dynamic>> changeEmail(
    final String email,
    final String password,
  ) async {
    final http.Response response = await client
        .put(
          Uri.parse(_host + _changeEmail),
          body: jsonEncode(<String, String>{
            "email": email,
            "password": password,
          }),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// PUT request to change the user's [currentPass]
  /// takes [newPass] & [confirmPass] to be compared in the backend
  Future<Map<String, dynamic>> changePassword(
    final String currentPass,
    final String newPass,
    final String confirmPass,
  ) async {
    final http.Response response = await client
        .put(
          Uri.parse(_host + _changePass),
          body: jsonEncode(<String, String>{
            "current_password": currentPass,
            "password": newPass,
            "password_confirmation": newPass,
          }),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Post request to log the [User] out
  Future<Map<String, dynamic>> logOut() async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _logOut),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// GET Request to the [Api] to get List of all personal [Blog]s (Profiles).
  Future<Map<String, dynamic>> getBlogs() async {
    final http.Response response = await http
        .get(
          Uri.parse(_host + _blog),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Post request to create a new [Blog]
  Future<Map<String, dynamic>> postNewBlog(
    final String blogUserName,
  ) async {
    final http.Response response = await client
        .post(
          Uri.parse(_host + _blog),
          headers: _headerContentAuth,
          body: jsonEncode(<String, String>{
            "title": "Untitled",
            "blog_username": blogUserName,
          }),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Get the details of a specific [Blog] using [blogID]
  Future<Map<String, dynamic>> getBlogInformation(
    final String blogID,
  ) async {
    final http.Response response = await client
        .get(
          Uri.parse(
            _host + _blog + "/" + blogID,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Get the Theme of a specific [Blog]
  Future<Map<String, dynamic>> getBlogTheme(
    final String blogID,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _blog + "/" + blogID + _theme,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Edits the [BlogTheme] of a specific [Blog],
  /// takes the [BlogTheme] which contains the themes info, and the
  /// [blogID] of that [Blog]
  Future<Map<String, dynamic>> setBlogTheme(
    final String blogID,
    final BlogTheme theme,
  ) async {
    final Map<String, String> body = <String, String>{
      "color_title": "#" + theme.titleColor,
      "font_title": theme.titleFont,
      "font_weight_title": theme.titleWeight,
      "title": theme.titleText,
      "background_color": "#" + theme.backgroundColor,
      "accent_color": "#" + theme.accentColor,
      "body_font": theme.bodyFont,
      "header_image": theme.headerImage,
      "avatar": theme.avatarURL,
      "avatar_shape": theme.avatarShape
    };

    if (theme.description.isNotEmpty) {
      body["description"] = theme.description;
    }

    final http.Response response = await http
        .put(
          Uri.parse(
            _host + _blog + "/" + blogID + _theme,
          ),
          headers: _headerContentAuth,
          body: jsonEncode(body),
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Get the Settings of a specific [Blog]
  /// takes the [blogID] of the [Blog]
  Future<Map<String, dynamic>> getBlogSetting(
    final String blogID,
  ) async {
    final http.Response response = await client
        .get(
          Uri.parse(
            _host + _blogSettings + blogID,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Get the info of a specific [User]
  Future<Map<String, dynamic>> getUserInfo(
    final String blogUsername,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _blog + _info + blogUsername,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// to get the [PostModel]s of a specific [Blog]
  Future<Map<String, dynamic>> fetchSpecificBlogPost(
    final String blogID,
    final int page,
  ) async {
    final http.Response response = await client
        .get(
          Uri.parse(
            _host + _posts + blogID + _published + "?page=$page",
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Get the Liked [PostModel]s of the personal [Blog]
  Future<Map<String, dynamic>> fetchLikedPost(
    final String blogID,
    final int page,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _blogsLikes + blogID + "?page=$page",
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Get the Followings of a specific [Blog]
  Future<Map<String, dynamic>> fetchFollowings(
    final String blogID,
    final int page,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(_host + _followings + blogID + "?page=$page"),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// to get the draft [PostModel]s of a specific [Blog]
  Future<Map<String, dynamic>> fetchDraftPost() async {
    final http.Response response = await client
        .get(
          Uri.parse(
            _host + _post + User.blogsIDs[User.currentProfile] + _draft,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// to follow specific [Blog], takes the [blogID]
  /// of the blog we wants to follow
  Future<Map<String, dynamic>> followBlog(final int blogID) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _followBlog + blogID.toString()),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// A post request to follow a [Tag]
  /// [tag] is the tag description
  Future<Map<String, dynamic>> followTag(final String tag) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _followTag + tag),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// A delete request to unfollow [Tag]
  Future<Map<String, dynamic>> unFollowTag(
    final String tagDescription,
  ) async {
    final String host = _host;
    final http.Response response = await http
        .delete(
          Uri.parse(
            host + _followedTags + tagDescription,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// A delete request to unfollow [Blog]
  Future<Map<String, dynamic>> unFollowBlog(final int blogID) async {
    final http.Response response = await http
        .delete(
          Uri.parse(_host + _followBlog + blogID.toString()),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// GET i follow a specific [Blog] with blogID [blogID]
  Future<Map<String, dynamic>> isMyFollowing(final int blogID) async {
    final http.Response response = await client
        .get(
          Uri.parse(
            _host + "/followed_by/" + blogID.toString(),
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Get the [PostModel]s of a specific [Tag] to display then in
  /// [TagPosts] page
  Future<Map<String, dynamic>> fetchTagPosts(
    final String tagDescription, {
    final bool recent = true,
    final int page = 1,
  }) async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(
            host +
                _tagPosts +
                tagDescription +
                (recent ? _recentPosts : _topPosts) +
                "&page=$page",
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Fetching words for typing in [SearchQuery] page
  /// it's called whenever the user types more than 2 letters
  /// its logic from the back is that they store any word came from
  /// the request of [fetchSearchResults] to their database and
  /// send it in the response of the autocomplete.
  Future<Map<String, dynamic>> fetchAutoComplete(
    final String word,
  ) async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _autoComplete + word),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Get all [Tag]s that a specific [Blog] follows in order to display
  /// it in [ManageTags] page and also in [SearchPage] "Explore Page"
  Future<Map<String, dynamic>> fetchTagsFollowed({final int page = 1}) async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _followedTags + "?page=$page"),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Getting all the details of a specific [Tag] : posts count,
  /// followers count, tag image, tag description and
  /// if the current blog is following this tag or not.
  Future<Map<String, dynamic>> fetchTagsDetails(
    final String tagDescription,
  ) async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _tagData + tagDescription),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// For fetching suggested tags to follow in [SearchPage] "explore"
  Future<Map<String, dynamic>> fetchCheckOutTags() async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _checkOutTags),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// For fetching suggested blogs to follow in [SearchPage] "explore"
  Future<Map<String, dynamic>> fetchCheckOutBlogs({
    final int page = 1,
  }) async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _checkOutBlogs + "?page=$page"),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Getting Random Posts, to display it in [RecommendedPosts] page,
  /// that is entered from [SearchPage]
  Future<Map<String, dynamic>> fetchRandomPosts({
    final int page = 1,
  }) async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _randomPosts + "?page=$page"),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    return jsonDecode(response.body);
  }

  /// Get trending tags to follow, will be displayed as
  /// suggested tags in [SearchPage] "Explore section"
  /// the response contains a single list of type [Tag]
  Future<Map<String, dynamic>> fetchTrendingTags() async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _getTrendingTags),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Fetching search query results for [SearchResult] page
  /// the response contains 3 lists of types [PostModel], [Tag], [Blog]
  Future<Map<String, dynamic>> fetchSearchResults(
    final String word, {
    final int page = 1,
  }) async {
    final String host = _host;
    final http.Response response = await http
        .get(
          Uri.parse(
            host + _search + word + "?page=$page",
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }

  /// Fetching search query results from searching in [ProfilePage]
  Future<Map<String, dynamic>> fetchSearchResultsProfile(
    final String word,
    final String blogID,
    final int page,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _search + blogID + "/" + word + "?$page",
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    return jsonDecode(response.body);
  }
}
