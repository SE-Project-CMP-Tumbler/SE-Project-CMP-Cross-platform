import "package:flutter/foundation.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/local_db.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Home_Page/home_page.dart";

/// Intermediate function that call [Api.logOut]
Future<bool> logOut() async {
  // TODO(Ziyad): Show dialog
  final Map<String, dynamic> response = await Api().logOut();

  if (response["meta"]["status"] == "200") {
    if (!kIsWeb) {
      await LocalDataBase.instance.deleteAllTable();
    }

    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }

    User.currentProfile = 0;
    User.age = 0;
    User.email = "";
    User.userID = "";
    User.accessToken = "";
    User.googleAccessToken = "";

    User.blogsIDs = <String>[];
    User.blogsNames = <String>[];
    User.avatars = <String>[];
    User.avatarShapes = <String>[];
    User.headerImages = <String>[];
    User.titles = <String>[];
    User.descriptions = <String>[];
    User.allowAsk = <bool>[];
    User.allowSubmission = <bool>[];
    User.isPrimary = <bool>[];

    homePosts.clear();
    await showToast("Logged Out");
    return true;
  } else {
    await showToast(response["meta"]["msg"]);
    return false;
  }
}
