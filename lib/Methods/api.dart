// ignore_for_file: prefer_interpolation_to_compose_strings
import "dart:convert";
import "dart:io" as io;

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:tumbler/Models/user.dart";

/// Class [Api] is used for all GET, POST, PUT, Delete request from the backend.
class Api {
  static const String _firebaseHost =
      "https://mock-back-default-rtdb.firebaseio.com";
  static const String _postmanMockHost="http://f677-193-227-10-6.ngrok.io";
  static const String _autocompleteMock= "https://run.mocky.io/v3/387362a2-6ceb-4ae7-88ad-d40aa3a7f3bf";
  static const String _mockSearch ="https://run.mocky.io/v3/1655e416-8421-41d6-9f75-0f03ab293a2f";
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

  /// When an error occur with any api request
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

  /// Make Post Request to the API to Sign Up
  Future<Map<String, dynamic>> signUp(
    final String blogUsername,
    final String password,
    final String email,
    final int age,
  ) async {
    final http.Response response = await http
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
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Sign Up with Google
  Future<Map<String, dynamic>> signUpWithGoogle(
    final String blogUsername,
    final String googleAccessToken,
    final int age,
  ) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _signUpWithGoogle),
          body: jsonEncode(<String, String>{
            "google_access_token": googleAccessToken,
            "blog_username": blogUsername,
            "age": age.toString(),
          }),
          headers: _headerContent,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Log In
  Future<Map<String, dynamic>> logIn(
    final String email,
    final String password,
  ) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _login),
          body: jsonEncode(<String, String>{
            "email": email,
            "password": password,
          }),
          headers: _headerContent,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Log In With Google
  Future<Map<String, dynamic>> logInWithGoogle(
    final String googleAccessToken,
  ) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _loginWithGoogle),
          body: jsonEncode(<String, String>{
            "google_access_token": googleAccessToken,
          }),
          headers: _headerContent,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// Make Post Request to the API to Send Forget Password Email.
  Future<Map<String, dynamic>> forgetPassword(final String email) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _forgotPassword),
          body: jsonEncode(<String, String>{
            "email": email,
          }),
          headers: _headerContent,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// Upload [video] to our server to get url of this video.
  Future<Map<String, dynamic>> uploadVideo(final String video) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _uploadVideo),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "b64_video": video,
          }),
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  ///get chats for that chats choose
  Future<Map<String, dynamic>> getChats() async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _chats),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  ///get chat messages
  Future<Map<String, dynamic>> getMessages(final String roomId) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _chatMessages + roomId),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "from_blog_id": User.blogsIDs[User.currentProfile],
          }),
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// send message
  Future<Map<String, dynamic>> sendMessages(
    final String text,
    final String photo,
    final String roomId,
  ) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _sendMessage + roomId),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{"text": text}),
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  ///get room id for chat
  Future<Map<String, dynamic>> getRoomId(final String toBlogId) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _chatRoom),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "from_blog_id": User.blogsIDs[User.currentProfile],
            "to_blog_id": toBlogId,
          }),
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// Upload [image] to our server to get url of this image.
  Future<Map<String, dynamic>> uploadImage(final String image) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _uploadImage),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "b64_image": image,
          }),
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// Upload [audio] to our server to get url of this audio.
  Future<Map<String, dynamic>> uploadAudio(final String audio) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _uploadAudio),
          headers: _headerContentAuth,
          body: json.encode(<String, String>{
            "b64_audio": audio,
          }),
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// Get all blogs of user
  Future<Map<String, dynamic>> getAllBlogs() async {
    final http.Response response = await http.get(
      Uri.parse(_host + _blog),
      headers: _headerContentAuth,
    );
    return jsonDecode(response.body);
  }

  /// Upload HTML code of the post.
  Future<Map<String, dynamic>> addPost(
    final String postBody,
    final String postStatus,
    final String postType,
    final String postTime,
  ) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _post + User.blogsIDs[User.currentProfile]),
          headers: _headerContentAuth,
          body: jsonEncode(<String, String>{
            "post_status": postStatus,
            "post_time": postTime,
            "post_type": postType,
            "post_body": postBody
          }),
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// Edit Post.
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
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// Delete Post.
  Future<Map<String, dynamic>> deletePost(
    final String postID,
  ) async {
    final http.Response response = await http
        .delete(
          Uri.parse(_host + _post + postID),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// get Post.
  Future<Map<String, dynamic>> getPost(
    final String postID,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(_host + _post + postID),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// GET Posts For the Home Page
  Future<Map<String, dynamic>> fetchHomePosts(final int page) async {
    final http.Response response = await http
        .get(
          Uri.parse(_host + _dashboard + "?page=$page"),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// GET Notes For the post with id [postID]
  Future<Map<String, dynamic>> getNotes(final String postID) async {
    final http.Response response = await http
        .get(
          Uri.parse(_host + _postNotes + postID),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// GET getPostLikeStatus for a post with id [postID]
  Future<Map<String, dynamic>> getPostLikeStatus(final int postID) async {
    final http.Response response = await http
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
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// To make Like on Post
  Future<Map<String, dynamic>> likePost(final int postId) async {
    final http.Response response = await http
        .post(
          Uri.parse(
            _host + _likePost + postId.toString(),
          ),
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// To Make Unlike on post
  Future<Map<String, dynamic>> unlikePost(final int postId) async {
    final http.Response response = await http
        .delete(
          Uri.parse(
            _host + _likePost + postId.toString(),
          ),
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  ///Sends a post request to reply on a post.
  Future<Map<String, dynamic>> replyOnPost(
    final String postId,
    final String text,
  ) async {
    final http.Response response = await http
        .post(
          Uri.parse(
            _host + _replyPost + postId,
          ),
          body: jsonEncode(<String, String>{
            "reply_text": text,
          }),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  ///Sends a post request to unfollow a blog.
  Future<Map<String, dynamic>> unfollowBlog(
    final String blogId,
  ) async {
    final http.Response response = await http
        .delete(
          Uri.parse(
            _host + _followBlog + blogId,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  ///Get notifications for activity page.
  Future<Map<String, dynamic>> getActivityNotifications(
    final String blogId,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _blog + "/" + blogId + "/notifications",
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// Upload HTML code of the reblog.
  Future<Map<String, dynamic>> reblog(
    final String blogId,
    final String parentPostId,
    final String postBody,
    final String postStatus,
    final String postType,
  ) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _reblog + blogId + "/" + parentPostId),
          headers: _headerContentAuth,
          body: jsonEncode(<String, String>{
            "post_status": postStatus,
            "post_type": postType,
            "post_body": postBody
          }),
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// PUT request to change the current user Email
  /// with [email]
  Future<Map<String, dynamic>> changeEmail(
    final String email,
    final String password,
  ) async {
    final http.Response response = await http
        .put(
          Uri.parse(_host + _changeEmail),
          body: jsonEncode(<String, String>{
            "email": email,
            "password": password,
          }),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// PUT request to change the current user Password
  /// with [email]
  Future<Map<String, dynamic>> changePassword(
    final String currentPass,
    final String newPass,
    final String confirmPass,
  ) async {
    final http.Response response = await http
        .put(
          Uri.parse(_host + _changePass),
          body: jsonEncode(<String, String>{
            "current_password": currentPass,
            "password": newPass,
            "password_confirmation": newPass,
          }),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// Post request to log out
  Future<Map<String, dynamic>> logOut() async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _logOut),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// blogs
  /// Make GET Request to the API to get List of all blogs (Profiles).
  Future<Map<String, dynamic>> getBlogs() async {
    final http.Response response = await http
        .get(
          Uri.parse(_host + _blog),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// Post a new blog
  Future<Map<String, dynamic>> postNewBlog(
    final String blogUserName,
  ) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _blog),
          headers: _headerContentAuth,
          body: jsonEncode(<String, String>{
            "title": "Untitled",
            "blog_username": blogUserName,
          }),
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// to get the Information of a specific blog
  Future<Map<String, dynamic>> getBlogInformation(
    final String blogID,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _blog + "/" + blogID,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// to get the Settings of a specific blog
  Future<Map<String, dynamic>> getBlogSetting(
    final String blogID,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _blogSettings + blogID,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// to get the posts of a specific blog
  Future<Map<String, dynamic>> fetchSpecificBlogPost(
    final String blogID,
    final int page,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _posts + blogID + _published + "?page=$page",
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// to get the Liked Posts of a My blog
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
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// to get the Following of a specific blog
  Future<Map<String, dynamic>> fetchFollowings(
    final String blogID,
    final int page,
  ) async {
    final http.Response response = await http
        .get(
          Uri.parse(_host + _followings + blogID + "?page=$page"),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// to get the draft posts of a specific blog
  Future<Map<String, dynamic>> fetchDraftPost() async {
    final http.Response response = await http
        .get(
          Uri.parse(
            _host + _posts + User.blogsIDs[User.currentProfile] + _draft,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// to follow specific blog
  Future<Map<String, dynamic>> followBlog(final int blogID) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _followBlog + blogID.toString()),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// to follow specific Tag
  Future<Map<String, dynamic>> followTag(final String tag) async {
    final http.Response response = await http
        .post(
          Uri.parse(_host + _followTag + tag),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// to unfollows specific tag
  Future<Map<String, dynamic>> unFollowTag(
    final String tagDescription, {
    final bool mock = false,
  }) async {
    final String host = mock ? _postmanMockHost : _host;
    final http.Response response = await http
        .delete(
          Uri.parse(
            host + _followedTags + tagDescription,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// to unfollow specific blog
  Future<Map<String, dynamic>> unFollowBlog(final int blogID) async {
    final http.Response response = await http
        .delete(
          Uri.parse(_host + _followBlog + blogID.toString()),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// get posts of specific tag
  Future<Map<String, dynamic>> fetchTagPosts(
    final String tagDescription, {
    final bool mock = false,
    final bool recent = true,
  }) async {
    final String host = mock ? _postmanMockHost : _host;
    final http.Response response = await http
        .get(
          Uri.parse(
            host +
                _tagPosts +
                tagDescription +
                (recent ? _recentPosts : _topPosts),
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// fetching words for auto complete search text field
  Future<Map<String, dynamic>> fetchAutoComplete(
    final String word, {
    final bool mock = false,
  }) async {
    final String host = mock ? _autocompleteMock : _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _autoComplete + word),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    // print("words autocomplete results");
    // print(response.body);

    return jsonDecode(response.body);
  }

  /// Tags requests
  /// fetch all the tags that a specific blog follows
  Future<Map<String, dynamic>> fetchTagsFollowed({
    final bool mock = false,
  }) async {
    final String host = mock ? _postmanMockHost : _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _followedTags),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// get the details of a specific tag
  Future<Map<String, dynamic>> fetchTagsDetails(
      final String tagDescription, {
    final bool mock = false,
  }) async {
    final String host = mock ? _postmanMockHost : _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _tagData +tagDescription),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// get "Check out these tags"
  Future<Map<String, dynamic>> fetchCheckOutTags({
    final bool mock = false,
  }) async {
    final String host = mock ? _postmanMockHost : _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _checkOutTags),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    // print("check out tags");
    // print(response.body);
    return jsonDecode(response.body);
  }

  /// get "Check out these blogs"
  Future<Map<String, dynamic>> fetchCheckOutBlogs({
    final bool mock = false,
  }) async {
    final String host = mock ? _postmanMockHost : _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _checkOutBlogs),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// get random posts
  Future<Map<String, dynamic>> fetchRandomPosts({
    final bool mock = false,
  }) async {
    final String host = mock ? _postmanMockHost : _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _randomPosts),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);

    return jsonDecode(response.body);
  }

  /// get trending tags to follow
  Future<Map<String, dynamic>> fetchTrendingTags({
    final bool mock = false,
  }) async {
    final String host = mock ? _postmanMockHost : _host;
    final http.Response response = await http
        .get(
          Uri.parse(host + _getTrendingTags),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }

  /// fetching words for search results
  Future<Map<String, dynamic>> fetchSearchResults(
    final String word, {
    final bool mock = false,
  }) async {
    final String host = mock ? _mockSearch : _host;
    final http.Response response = await http
        .get(
          Uri.parse(
            host + _search + word,
          ),
          headers: _headerContentAuth,
        )
        .onError(errorFunction);
    return jsonDecode(response.body);
  }
}
