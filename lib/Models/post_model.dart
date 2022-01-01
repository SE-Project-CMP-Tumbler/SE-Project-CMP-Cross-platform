///Post Model
class PostModel {
  /// Constructor
  PostModel({
    required final this.postId,
    required final this.postBody,
    required final this.postStatus,
    required final this.postType,
    required final this.blogId,
    required final this.blogUsername,
    required final this.blogAvatar,
    required final this.blogAvatarShape,
    required final this.blogTitle,
    required final this.postTime,
    required this.notes,
    required this.isLoved,
    required final this.isFollowed,
    required final this.traceBackPosts,
    required final this.isPinned,
  });

  /// ID of the Post
  final int postId;

  /// Html Body of the Post
  final String postBody;

  /// Status of the Post
  final String postStatus;

  /// Type of the Post
  final String postType;

  /// ID of the Blog added this Post
  final int blogId;

  /// Username of the Blog added this Post
  final String blogUsername;

  /// URL of the Avatar of the Blog added this Post
  final String blogAvatar;

  /// Shape of the Avatar
  final String blogAvatarShape;

  /// Title of the Blog added this Post
  final String blogTitle;

  /// Time at which the post was added
  final String postTime;

  /// Boolean to indicate if the post is pinned
  final bool isPinned;

  /// Trace Back Posts (if the post was rebloged)
  final List<dynamic> traceBackPosts;

  /// Number of notes of the post
  int notes;

  /// Boolean to indicate if the post was liked by me
  bool isLoved;

  /// Boolean to indicate if th follow the blog added this post
  bool isFollowed;

  /// Converts JSON["response"]["posts"] to List of Posts
  static Future<List<PostModel>> fromJSON(
    final List<dynamic> json,
  ) async {
    final List<PostModel> temp = <PostModel>[];
    for (int i = 0; i < json.length; i++) {
      if (!((json[i]["pinned"] ?? false) as bool)) {
        temp.add(
          PostModel(
            postId: json[i]["post_id"] as int,
            postBody: json[i]["post_body"] ?? "",
            postStatus: json[i]["post_status"] ?? "",
            postType: json[i]["post_type"] ?? "",
            blogId: json[i]["blog_id"] as int,
            blogUsername: json[i]["blog_username"] ?? "",
            blogAvatar: json[i]["blog_avatar"] ?? "",
            blogAvatarShape: json[i]["blog_avatar_shape"] ?? "",
            blogTitle: json[i]["blog_title"] ?? "",
            postTime: json[i]["post_time"] ?? "",
            notes: (json[i]["notes_count"] ?? 0) as int,
            isLoved: (json[i]["is_liked"] ?? false) as bool,
            isFollowed: (json[i]["followed"] ?? true) as bool,
            traceBackPosts: json[i]["traced_back_posts"],
            isPinned: (json[i]["pinned"] ?? false) as bool,
          ),
        );
      } else {
        temp.insert(
          0, // insert at first
          PostModel(
            postId: json[i]["post_id"] as int,
            postBody: (json[i]["post_body"] ?? "") +
                " <p style='color:green'><strong>Pinned Post</strong></p>",
            postStatus: json[i]["post_status"] ?? "",
            postType: json[i]["post_type"] ?? "",
            blogId: json[i]["blog_id"] as int,
            blogUsername: json[i]["blog_username"] ?? "",
            blogAvatar: json[i]["blog_avatar"] ?? "",
            blogAvatarShape: json[i]["blog_avatar_shape"] ?? "",
            blogTitle: json[i]["blog_title"] ?? "",
            postTime: json[i]["post_time"] ?? "",
            notes: (json[i]["notes_count"] ?? 0) as int,
            isLoved: (json[i]["is_liked"] ?? false) as bool,
            isFollowed: (json[i]["followed"] ?? true) as bool,
            traceBackPosts: json[i]["traced_back_posts"],
            isPinned: (json[i]["pinned"] ?? false) as bool,
          ),
        );
      }
    }
    return temp;
  }
}
