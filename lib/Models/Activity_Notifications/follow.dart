///[Follow] represents the follow notification
class Follow {
  /// takes dateTime, avatarUrl, userName
  Follow({
    required final this.dateTime,
    required final this.avatarUrl,
    required final this.userName,
  });

  /// holds the start time of following
  DateTime dateTime;

  /// holds the url of the blog avatar of the new follower
  String avatarUrl;

  /// holds the user name of the new follower
  String userName;

  /// the type of class
  String type = "follow";
}
