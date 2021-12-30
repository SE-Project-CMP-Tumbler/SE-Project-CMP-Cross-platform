import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/initializer.dart";
import "package:tumbler/Methods/local_db.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Intro_Carousel/intro_carousel.dart";
import "package:tumbler/Screens/main_screen.dart";

/// Page To get The User Age
class SignUpGoogle extends StatefulWidget {
  @override
  State<SignUpGoogle> createState() => _SignUpGoogleState();
}

class _SignUpGoogleState extends State<SignUpGoogle> {
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Call API Sign Up Function
  ///
  /// Get the [response] from the [Api.signU] function
  /// and sets [User.name], [User.id], [User.blogAvatar]
  /// , [User.accessToken] from the database if no error happened.
  Future<void> signUp() async {
    final Map<String, dynamic> response = await Api().signUpWithGoogle(
      _controller.text,
      User.googleAccessToken,
      User.age,
    );

    if (response["meta"]["status"] == "200") {
      User.email = response["response"]["email"];
      User.userID = response["response"]["id"].toString();
      User.accessToken = response["response"]["access_token"];
      // the index of the primary user
      User.currentProfile = 0;

      if (!kIsWeb) {
        await LocalDataBase.instance.insertIntoUserTable(
          User.userID,
          User.email,
          User.age,
          User.accessToken,
          User.currentProfile,
        );
      }
      // Note: May be it is not wanted in sign up
      // he only has one blog
      await initializeUserBlogs();

      if (!kIsWeb) {
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<IntroCarousel>(
            builder: (final BuildContext context) => IntroCarousel(),
          ),
          (final Route<dynamic> route) => false,
        );
      } else {
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<MainScreen>(
            builder: (final BuildContext context) => MainScreen(),
          ),
          (final Route<dynamic> route) => false,
        );
      }
    } else {
      await showToast(response["meta"]["msg"]);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Create username"),
          backgroundColor: appBackgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Create a username",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controller,
                    onChanged: (final String s) => setState(() {}),
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.blue,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: formEnabledFieldBorderStyle,
                      focusedBorder: formFocusedFieldBorderStyle,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 100,
                  child: ElevatedButton(
                    onPressed: _controller.text.isEmpty
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await signUp();
                            }
                          },
                    style: ButtonStyle(
                      backgroundColor: _controller.text.isEmpty
                          ? MaterialStateProperty.all<Color>(Colors.grey)
                          : MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
