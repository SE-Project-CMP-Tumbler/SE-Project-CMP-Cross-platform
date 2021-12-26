/// the profile of a user has at least one blog
/// the blog carries all the information about the posts
class Blog {
  /// constructor of a blog
  Blog({
    required final this.blogId,
    required final this.isPrimary,
    required final this.username,
    required final this.avatarImageUrl,
    required final this.avatarShape,
    required final this.headerImage,
    required final this.blogTitle,
    required final this.allowAsk,
    required final this.allowSubmission,
    required final this.blogDescription,
  });

  /// blog id
  String? blogId;

  /// is this the primary blog or not
  bool? isPrimary;

  /// user name of the blog, each blog has a different username
  String? username;

  /// avatar image
  String? avatarImageUrl;

  /// avatar image shape
  String? avatarShape;

  /// cover Image
  String? headerImage;

  /// blog title
  String? blogTitle;

  /// allow asks or not
  bool? allowAsk;

  /// allow submissions or not
  bool? allowSubmission;

  /// blog description
  String? blogDescription;
}
