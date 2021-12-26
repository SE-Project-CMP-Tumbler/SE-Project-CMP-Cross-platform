import "package:tumbler/Models/post.dart";

/// the tags that appear on the search page
class Tag{
  /// constructor of a tag
  Tag({
    required final this.tagDescription,
    required final this.tagImgUrl,
    final this.isFollowed,
    final this.followersCount,
    final this.postsCount,
    final this.tagPosts,
  });

  /// tag title
  String? tagDescription;

  /// url of the tag image
  String? tagImgUrl;

  /// is the current user following this tag or not
  bool? isFollowed;

  /// number of the followers of a specific tag
  int? followersCount;

  /// list of the posts associated with this tag
  List<Post>? tagPosts;

  /// count of posts that has this tag
  int? postsCount;

}
