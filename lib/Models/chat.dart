/// Model of the Chat
class Chat {
  /// Constructor
  Chat(
    this.lastMessage,
    this.photo,
    this.blogID,
    this.blogUsername,
    this.blogAvatar,
    this.blogAvatarShape,
    this.blogTitle,
    this.read,
  );

  /// Last Message sent in this chat
  String lastMessage;

  /// Photo Url
  String photo;

  /// Blog ID of the Chatter
  int blogID;

  /// Blog Username
  String blogUsername;

  /// URL of the Blog Avatar
  String blogAvatar;

  /// Shape of the Blog Avatar
  String blogAvatarShape;

  /// Title of the Blog
  String blogTitle;

  /// Boolean to indicate if the user has read the message or no
  bool read;
}
