/// Model of the Follower Class
class Follower {
  /// Constructor
  Follower({
    required final this.blogAvatar,
    required final this.blogID,
    required final this.blogAvatarShape,
    required final this.blogUsername,
  });

  /// URL of the Blog
  String blogAvatar;

  /// Shape of the Avatar
  String blogAvatarShape;

  /// Username of the Blog
  String blogUsername;

  /// ID of the Blog
  int blogID;

  /// Boolean to indicate if i follow he/she
  late bool isFollowedByMe;
}
