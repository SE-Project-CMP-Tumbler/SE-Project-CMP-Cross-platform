
class Ask {
  Ask(
      {required final this.dateTime,
      required final this.avatarUrl,
      required final this.userName,
      required final this.quesiton});

  DateTime dateTime;
  String avatarUrl;
  String userName;
  String quesiton;

  String type = "ask";
}
