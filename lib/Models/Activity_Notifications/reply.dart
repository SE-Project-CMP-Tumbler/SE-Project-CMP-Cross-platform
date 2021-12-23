
class Reply {
  Reply(
      {required final this.dateTime,
      required final this.avatarUrl,
      required final this.userName,
      required final this.reply});

  DateTime dateTime;
  String avatarUrl;
  String userName;
  String reply;

  String type = "reply";
}
