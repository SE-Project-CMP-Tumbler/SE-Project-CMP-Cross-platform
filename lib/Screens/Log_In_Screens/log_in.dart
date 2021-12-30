import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/email_password_validators.dart";
import "package:tumbler/Methods/initializer.dart";
import "package:tumbler/Methods/local_db.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Log_In_Screens/forget_password.dart";
import "package:tumbler/Screens/main_screen.dart";

/// Log In Page
class LogIN extends StatefulWidget {
  @override
  _LogINState createState() => _LogINState();
}

class _LogINState extends State<LogIN> {
  late TextEditingController _passController;
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _passController = TextEditingController();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _passController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Form form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              validator: emailValidator,
              controller: _emailController,
              onChanged: (final String s) => setState(() {}),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: formEnabledFieldBorderStyle,
                focusedBorder: formFocusedFieldBorderStyle,
                hintStyle: const TextStyle(color: Colors.white30),
                hintText: "Email",
                suffixIcon: _emailController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () =>
                            setState(() => _emailController.clear()),
                        color: Colors.white30,
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              validator: passValidator,
              controller: _passController,
              onChanged: (final String s) => setState(() {}),
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  color: Colors.white,
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                enabledBorder: formEnabledFieldBorderStyle,
                focusedBorder: formFocusedFieldBorderStyle,
                hintStyle: const TextStyle(color: Colors.white30),
                hintText: "Password",
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Call API Log In Function.
  /// Get the [response] from the [Api.LogIn] function
  /// and sets [User.name], [User.userID], [User.blogAvatar],
  /// [User.accessToken] from the database if no error happened.
  Future<void> logIn() async {
    final Map<String, dynamic> response =
        await Api().logIn(_emailController.text, _passController.text);

    if (response["meta"]["status"] == "200") {
      User.email = response["response"]["email"];
      User.userID = response["response"]["id"].toString();
      User.accessToken = response["response"]["access_token"];
      print("access token is:${User.accessToken}");
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
  }

  @override
  Widget build(final BuildContext context) {
    final AppBar appBar = AppBar(
      backgroundColor: appBackgroundColor,
      title: const Image(
        image: AssetImage("assets/images/logo_letter.png"),
        height: 45,
      ),
      centerTitle: true,
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await logIn();
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Log In",
                style: TextStyle(
                  fontSize: 15,
                  color: (_emailController.text.isEmpty ||
                          _passController.text.isEmpty)
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.blue,
                ),
              ),
            ),
          ),
        )
      ],
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: appBar,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: form(),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<ForgetPassWord>(
                        builder: (final BuildContext context) =>
                            ForgetPassWord(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forget Password",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 19,
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.underline,
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
