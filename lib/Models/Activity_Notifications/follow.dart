
class Follow {
  Follow(
      {required final this.dateTime,
      required final this.avatarUrl,
      required final this.userName,});

  DateTime dateTime;
  String avatarUrl;
  String userName;

  String type = "follow";
}
