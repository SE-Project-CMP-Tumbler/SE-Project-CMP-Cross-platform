
///[Mention] models the mention notification
class Mention {
  /// [Mention] constructor
   Mention(
      {required final this.dateTime,
      required final this.avatarUrl,
      required final this.userName,});

  /// holds the time the mention happend
   DateTime dateTime;
  /// holds the avatar url of the one mentioning
  final String avatarUrl;
  /// holds the user name of the one mentioning
  final String userName;

  /// the type of the class /  notification
 String type = "mention";
}
