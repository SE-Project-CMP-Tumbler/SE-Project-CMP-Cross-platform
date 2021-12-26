
///[Reply] represents the reply notification
class Reply {
  /// [Reply] constructor
   Reply(
      {required final this.dateTime,
      required final this.avatarUrl,
      required final this.userName,
      required final this.reply,});

  /// date time of the reply
   DateTime dateTime;
  /// the avatar url of the one replying
  final String avatarUrl;
  /// the user name of the one replying
  final String userName;
  /// the reply itself
  final String reply;

  /// the type of the class / notification
  String type = "reply";
}
