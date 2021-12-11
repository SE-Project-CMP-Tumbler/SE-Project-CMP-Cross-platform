import "package:tumbler/Methods/api.dart";
import "package:tumbler/Models/user.dart";

/// Fill the User model class with the
/// user data
Future<bool> fillUserBlogs() async {
  final Map<String, dynamic> response = await Api().getAllBlogs();

  if (response["meta"]["status"] == "200") {
    User.blogsNames.clear();
    User.blogsIDs.clear();
    User.blogsNames.clear();
    User.avatars.clear();
    User.avatarShapes.clear();
    User.headerImages.clear();
    User.titles.clear();
    User.allowAsk.clear();
    User.allowSubmission.clear();
    User.descriptions.clear();
    User.isPrimary.clear();
    final List<dynamic> blogs = response["response"]["blogs"];
    for (final Map<String, dynamic> blog in blogs) {
      if (!(blog["is_primary"] as bool)) {
        User.blogsIDs.add(blog["id"].toString());
        User.blogsNames.add(blog["username"] ?? " ");
        User.avatars.add(blog["avatar"] ?? " ");
        User.avatarShapes.add(blog["avatar_shape"] ?? " ");
        User.headerImages.add(blog["header_image"] ?? " ");
        User.titles.add(blog["title"] ?? " ");
        User.allowAsk.add(blog["allow_ask"] as bool);
        User.allowSubmission.add(blog["allow_submittions"] as bool);
        User.descriptions.add(blog["description"] ?? " ");
        User.isPrimary.add(blog["is_primary"] as bool);
      } else {
        /// if primary , then insert at the beginning
        User.blogsIDs.insert(0, blog["id"].toString());
        User.blogsNames.insert(0, blog["username"] ?? " ");
        User.avatars.insert(0, blog["avatar"] ?? " ");
        User.avatarShapes.insert(0, blog["avatar_shape"] ?? " ");
        User.headerImages.insert(0, blog["header_image"] ?? " ");
        User.titles.insert(0, blog["title"] ?? " ");
        User.allowAsk.insert(0, blog["allow_ask"] as bool);
        User.allowSubmission.insert(0, blog["allow_submittions"] as bool);
        User.descriptions.insert(0, blog["description"] ?? " ");
        User.isPrimary.add(blog["is_primary"] as bool);

      }
    }
    print(User.blogsNames);
    return true;
  } else {
    return false;
  }
}
