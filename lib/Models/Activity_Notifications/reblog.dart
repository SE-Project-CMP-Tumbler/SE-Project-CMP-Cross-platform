/// [Reblog] represents the reblog notification
class Reblog {
  /// [Reblog] constructor
  Reblog({
    required final this.dateTime,
    required final this.avatarUrl,
    required final this.userName,
    required final this.postID,
  });

  ///postID to reply on
  int postID;

  /// the time of the reblog
  DateTime dateTime;

  /// the url of the blog avatar
  final String avatarUrl;

  /// the userName of the one rebloging
  final String userName;

  /// the type of the class / notification
  String type = "reblog";
}
