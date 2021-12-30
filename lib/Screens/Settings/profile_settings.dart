import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Methods/log_out.dart";
import "package:tumbler/Models/user.dart";
import 'package:tumbler/Providers/followed_tags_sign_up.dart';
import 'package:tumbler/Providers/tags.dart';
import "package:tumbler/Screens/On_Start_Screens/on_start_screen.dart";
import "package:tumbler/Screens/Settings/change_email.dart";
import "package:tumbler/Screens/Settings/change_name.dart";
import "package:tumbler/Screens/Settings/change_password.dart";
import "package:tumbler/Screens/Settings/show_draft.dart";

/// Setting Page
class ProfileSettings extends StatelessWidget {
  /// Constructor
  const ProfileSettings({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<ChangeName>(
                    builder: (final BuildContext context) => const ChangeName(),
                  ),
                );
              },
              child: const Text(
                "Change Name",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<ChangeEmail>(
                    builder: (final BuildContext context) =>
                        const ChangeEmail(),
                  ),
                );
              },
              child: const Text(
                "Change Email",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<ChangePassword>(
                    builder: (final BuildContext context) =>
                        const ChangePassword(),
                  ),
                );
              },
              child: const Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<ShowDraft>(
                    builder: (final BuildContext context) => const ShowDraft(),
                  ),
                );
              },
              child: Text(
                "Draft of ${User.blogsNames[User.currentProfile]}",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<ShowDraft>(
                    builder: (final BuildContext context) => const ShowDraft(),
                  ),
                );
              },
              child: Text(
                "Followers of ${User.blogsNames[User.currentProfile]}",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (await logOut()) {
                  Provider.of<FollowedTags>(context, listen: false)
                      .followedTags
                      .clear();
                  Provider.of<Tags>(context, listen: false).resetAll();
                  await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<OnStart>(
                      builder: (final BuildContext context) => OnStart(),
                    ),
                    (final Route<dynamic> route) => false,
                  );
                }
              },
              child: const Text(
                "Log out",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
