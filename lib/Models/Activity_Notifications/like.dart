///[Like] represents the like notification
class Like {
  /// [Like] constructor
  Like({
    required final this.dateTime,
    required final this.avatarUrl,
    required final this.userName,
    required final this.postID,
  });

  ///postID to reply on
  int postID;

  /// holds the date the like happened
  DateTime dateTime;

  /// holds the avatar url of the one liking the post
  String avatarUrl;

  /// holds the user name of the one liked the post
  String userName;

  /// the type of the class / notification
  String type = "like";
}
