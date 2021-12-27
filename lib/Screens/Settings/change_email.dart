import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/email_password_validators.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/main_screen.dart";

/// Change Email Page
class ChangeEmail extends StatefulWidget {
  /// Constructor
  const ChangeEmail({final Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Call API Change Email Function.
  ///
  /// Get the [response] from the [Api.ChangeEmail] function
  /// and change [User.email]
  Future<void> changeEmail(final String pass) async {
    final Map<String, dynamic> response =
        await Api().changeEmail(_emailController.text, pass);

    if (response["meta"]["status"] == "200") {
      User.email = response["response"]["email"];

      await showToast("You successfully updated your Email!");

      // TODO(Ziyad): Restart the app? or log out ?
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<MainScreen>(
          builder: (final BuildContext context) => MainScreen(),
        ),
        (final Route<dynamic> route) => false,
      );
      return;
    } else {
      await showToast(response["meta"]["msg"]);
    }
  }

  Future<void> showConfirmPasswordDialog(
    final BuildContext context,
    final String content,
  ) async {
    bool _obscureText2 = true;
    final TextEditingController _passController2 = TextEditingController();
    await showDialog(
      context: context,
      builder: (final BuildContext ctx) {
        if (Platform.isAndroid) {
          return StatefulBuilder(
            builder: (final BuildContext context, final Function setState) {
              return AlertDialog(
                backgroundColor: appBackgroundColor,
                title: const Text(
                  "Not so fast",
                  style: TextStyle(color: Colors.white),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        content,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: _passController2,
                      onChanged: (final String s) => setState(() {}),
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white),
                      obscureText: _obscureText2,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.white,
                          onPressed: () =>
                              setState(() => _obscureText2 = !_obscureText2),
                          icon: Icon(
                            _obscureText2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        enabledBorder: formEnabledFieldBorderStyle,
                        focusedBorder: formFocusedFieldBorderStyle,
                        hintStyle: const TextStyle(color: Colors.white30),
                        hintText: "Password",
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      changeEmail(_passController2.text);
                    },
                    child: const Text("Confirm"),
                  )
                ],
              );
            },
          );
        } else {
          return StatefulBuilder(
            builder: (final BuildContext context, final Function setState) {
              return CupertinoAlertDialog(
                title: const Text("Not so fast"),
                content: Column(
                  children: <Widget>[
                    Text(content),
                    TextField(
                      controller: _passController2,
                      onChanged: (final String s) => setState(() {}),
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white),
                      obscureText: _obscureText2,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.white,
                          onPressed: () =>
                              setState(() => _obscureText2 = !_obscureText2),
                          icon: Icon(
                            _obscureText2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        enabledBorder: formEnabledFieldBorderStyle,
                        focusedBorder: formFocusedFieldBorderStyle,
                        hintStyle: const TextStyle(color: Colors.white30),
                        hintText: "Password",
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      changeEmail(_passController2.text);
                    },
                    child: const Text("Confirm"),
                  )
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        leadingWidth: 70,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white60,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await showConfirmPasswordDialog(
                  context,
                  "To Change your e-mail, please confirm your password.",
                );
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 15,
                    color: (_emailController.text.isEmpty)
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.blue,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Change Email",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: TextFormField(
                validator: emailValidator,
                onChanged: (final String email) => setState(() {}),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: formEnabledFieldBorderStyle,
                  focusedBorder: formFocusedFieldBorderStyle,
                  hintStyle: const TextStyle(color: Colors.white30),
                  hintText: "New Email",
                  suffixIcon: _emailController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(_emailController.clear),
                          color: Colors.white30,
                        )
                      : null,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "Notice: This will be the email "
              "you'll use to log in from now on.",
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
