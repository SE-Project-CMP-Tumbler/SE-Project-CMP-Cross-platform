import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/initializer.dart";
import "package:tumbler/Methods/local_db.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Sign_Up_Screens/With_Google/get_age.dart";
import "package:tumbler/Screens/main_screen.dart";

/// To Sign up with Google
/// to get the user main Data
/// and the token
Future<void> signUpWithGoogle(final BuildContext context) async {
  await GoogleSignIn()
      .signIn()
      .then((final GoogleSignInAccount? userData) async {
    if (userData != null) {
      User.googleAccessToken = userData.serverAuthCode.toString();
      await Navigator.of(context).push(
        MaterialPageRoute<GetAgeGoogle>(
          builder: (final BuildContext context) => GetAgeGoogle(),
        ),
      );
    } else
      await showToast("Failed to connect to Google");
  }).timeout(
    const Duration(seconds: 10),
    onTimeout: () async {
      await showToast("Failed to  connect ot google");
    },
  ).onError((final Object? error, final StackTrace stackTrace) async {
    await showToast("Something failed");
  });
}

/// To Log In with Google
/// to get the user main Data
/// and the token
Future<void> logInWithGoogle(final BuildContext context) async {
  await GoogleSignIn()
      .signIn()
      .then((final GoogleSignInAccount? userData) async {
    if (userData != null) {
      User.googleAccessToken = userData.serverAuthCode.toString();
      final Map<String, dynamic> response =
          await Api().logInWithGoogle(User.googleAccessToken);

      if (response["meta"]["status"] == "200") {
        User.email = response["response"]["email"];
        User.userID = response["response"]["id"].toString();
        User.accessToken = response["response"]["access_token"];
        // the index of the primary user
        User.currentProfile = 0;

        // TODO(Ziyad): this should be fixed properly
        if (!kIsWeb) {
          await LocalDataBase.instance.insertIntoUserTable(
            User.userID,
            User.email,
            User.age,
            User.accessToken,
            User.currentProfile,
          );
        }
        await initializeUserBlogs();

        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<MainScreen>(
            builder: (final BuildContext context) => MainScreen(),
          ),
          (final Route<dynamic> route) => false,
        );
      } else {
        await showToast(response["meta"]["msg"]);
      }
    } else
      await showToast("Failed to connect to Google");
  }).timeout(
    const Duration(seconds: 10),
    onTimeout: () async {
      await showToast("Failed to  connect ot google");
    },
  );
}
