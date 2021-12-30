///[Notes] list of likes and reblogs and replies on a post
class Notes {
  /// [Notes] constructor
  const Notes({
    required final this.likes,
    required final this.reblogs,
    required final this.replies,
  });

  /// list of like notification
  final List<dynamic> likes;

  /// list of reblogs notification
  final List<dynamic> reblogs;

  /// list of replies notification
  final List<dynamic> replies;
}
