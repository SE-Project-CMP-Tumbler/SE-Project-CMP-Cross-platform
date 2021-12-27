
///[Ask] class models ask notification
class Ask {

  /// takes date time and avatar url and user name and question asked
   Ask(
      {required final this.dateTime,
      required final this.avatarUrl,
      required final this.userName,
      required final this.quesiton,});

  /// dateTime saves the date time of the question
   DateTime dateTime;
  /// avatarUrl save the url of the blog avatar 
  final String avatarUrl;
  /// userName saves the user name of the user asking
  final String userName;
  /// question saves the question asked
  final String quesiton;

  /// saves the type of class
   String type = "ask";
}
