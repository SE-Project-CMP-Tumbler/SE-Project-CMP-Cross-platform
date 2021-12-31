// ignore_for_file: public_member_api_docs

class Follower {
  Follower(
      {required final this.blog_avatar,
        required final this.blog_id,
        required final this.blog_avatar_shape,
        required final this.blog_username});

  String blog_avatar;
  String blog_avatar_shape;
  String blog_username;
  int blog_id;
  late bool isFollowedByMe;
}