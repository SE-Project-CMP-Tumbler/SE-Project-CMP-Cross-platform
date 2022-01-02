import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/email_password_validators.dart";
import "package:tumbler/Methods/log_out.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Screens/On_Start_Screens/on_start_screen.dart";

/// Change Password Page
class ChangePassword extends StatefulWidget {
  /// Constructor
  const ChangePassword({final Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  Future<void> changePass(final String oldPass) async {
    // we don't have confirm password
    final Map<String, dynamic> response = await Api().changePassword(
      oldPass,
      _passController.text,
      _passController.text,
    );

    if (response["meta"]["status"] == "200") {
      await showToast("You successfully updated your Password!");

      if (await logOut())
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<OnStart>(
            builder: (final BuildContext context) => OnStart(),
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
    bool _obscureDialogText = true;
    final TextEditingController _passDialogController = TextEditingController();
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
                      controller: _passDialogController,
                      onChanged: (final String s) => setState(() {}),
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white),
                      obscureText: _obscureDialogText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.white,
                          onPressed: () => setState(
                            () => _obscureDialogText = !_obscureDialogText,
                          ),
                          icon: Icon(
                            _obscureDialogText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        enabledBorder: formEnabledFieldBorderStyle,
                        focusedBorder: formFocusedFieldBorderStyle,
                        hintStyle: const TextStyle(color: Colors.white30),
                        hintText: "Password",
                      ),
                    ),
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
                    onPressed: () async {
                      await changePass(_passDialogController.text);
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(content),
                    ),
                    TextField(
                      controller: _passDialogController,
                      onChanged: (final String s) => setState(() {}),
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white),
                      obscureText: _obscureDialogText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.white,
                          onPressed: () => setState(
                            () => _obscureDialogText = !_obscureDialogText,
                          ),
                          icon: Icon(
                            _obscureDialogText
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
                    onPressed: () async {
                      await changePass(_passDialogController.text);
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
                  "To use your new password, "
                  "please enter your last used password. "
                  "Once confirmed, you will need to log in again.",
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
                    color: (_passController.text.isEmpty)
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.blue,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Change Password",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: passValidator,
                  onChanged: (final String pass) => setState(() {}),
                  controller: _passController,
                  keyboardType: TextInputType.name,
                  obscureText: _obscureText,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: formEnabledFieldBorderStyle,
                    focusedBorder: formFocusedFieldBorderStyle,
                    hintStyle: const TextStyle(color: Colors.white30),
                    hintText: "New Password",
                    suffixIcon: _passController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => setState(
                              () => _obscureText = !_obscureText,
                            ),
                            color: Colors.white30,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
