import "package:tumbler/Methods/get_all_blogs.dart";
import "package:tumbler/Methods/local_db.dart";
import "package:tumbler/Models/user.dart";

/// Initialize the Main Data of the User Model
Future<void> initializeUserData() async {
  final Map<String, dynamic> user = await LocalDataBase.instance.getUserTable();

  User.userID = user["userID"] ?? "";
  User.email = user["email"] ?? "";
  User.age = user["age"] ?? 0;
  User.accessToken = user["accessToken"] ?? "";
  User.currentProfile = user["currentProfile"] ?? 0;
}

/// Initialize the User Blogs
Future<void> initializeUserBlogs() async {
  // There is no User Signed In
  if (User.accessToken.isEmpty) {
    return;
  }

  await fillUserBlogs();
  await LocalDataBase.instance.deleteUserBlogTable();

  for (int i = 0; i < User.blogsIDs.length; i++) {
    await LocalDataBase.instance.insertIntoUserBlogTable(
      User.blogsIDs[i],
      User.blogsNames[i],
      User.avatars[i],
      User.avatarShapes[i],
      User.headerImages[i],
      User.titles[i],
      User.descriptions[i],
      User.allowAsk[i],
      User.allowSubmission[i],
    );
  }
}
