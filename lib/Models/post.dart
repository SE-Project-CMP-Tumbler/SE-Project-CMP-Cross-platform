// ignore_for_file: public_member_api_docs
///Post Model
class Post {
  Post({
    required final this.postId,
    required final this.postBody,
    required final this.postStatus,
    required final this.postType,
    required final this.blogId,
    required final this.blogUsername,
    required final this.blogAvatar,
    required final this.blogAvatarShape,
    required final this.blogTitle,
    required final this.postTime,
    final this.likes = const <dynamic>[],
    final this.reblogs = const <dynamic>[],
    final this.replies = const <dynamic>[],
  });

  final int postId;
  final String postBody;
  final String postStatus;
  final String postType;
  final int blogId;
  final String blogUsername;
  final String blogAvatar;
  final String blogAvatarShape;
  final String blogTitle;
  final String postTime;
  List<dynamic> likes = <dynamic>[];
  List<dynamic> reblogs = <dynamic>[];
  List<dynamic> replies = <dynamic>[];
}
