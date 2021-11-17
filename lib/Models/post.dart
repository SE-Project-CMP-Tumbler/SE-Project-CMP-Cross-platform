// THIS MODEL IS NOT FINAL .  IT IS CREATED FOR TESTING PURPOSES.
class Post {
  String postId = " ";
  String postBody = "";
  //String postStatus = "";
  bool isFavorite = false;
  //String blogId = "";
  //String blogUserName = "";
  String postUserName = "";
  String postType = "";
  String postAvatar = "";
  //String blogAvatarShape = "";
  //String blogTitle = "";
  String postTime = "";
  int notesNum = 0;

  Post({
    required this.postId,
    required this.postBody,
    required this.isFavorite,
    required this.postUserName,
    required this.postAvatar,
    required this.notesNum,
  });
}
