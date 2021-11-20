///Post Model
class Post {
  int postId;
  String postBody;
  String postStatus;
  String postType;
  int blogId;
  String blogUsername;
  String blogAvatar;
  String blogAvatarShape;
  String blogTitle;
  String postTime;
  List<dynamic> likes = [];
  List<dynamic> reblogs = [];
  List<dynamic> replies = [];

  Post({
    required this.postId,
    required this.postBody,
    required this.postStatus,
    required this.postType,
    required this.blogId,
    required this.blogUsername,
    required this.blogAvatar,
    required this.blogAvatarShape,
    required this.blogTitle,
    required this.postTime,
    this.likes = const [],
    this.reblogs = const [],
    this.replies = const [],
  });
}
