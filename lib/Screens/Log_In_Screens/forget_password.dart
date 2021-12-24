import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";

/// Forget Password Page
class ForgetPassWord extends StatefulWidget {
  @override
  _ForgetPassWordState createState() => _ForgetPassWordState();
}

class _ForgetPassWordState extends State<ForgetPassWord> {
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;

  /// Toggle the page view if the reset
  /// password email has been successfully sent.
  bool firstHomePage = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Request to send reset password email
  ///
  /// Get the [response] from the [Api.forgetPassword] function
  /// and confirm the user that the email has been sent.
  Future<void> forgetPassword() async {
    final Map<String, dynamic> response =
        await Api().forgetPassword(_emailController.text);

    if (response["meta"]["status"] == "200")
      setState(() => firstHomePage = false);
    else
      await showToast(response["meta"]["msg"]);
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
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
                  await forgetPassword();
                }
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Submit",
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
        body: firstHomePage
            ? Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Forget your password? It happens.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "We'll send you a link to reset it.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (final String? s) => s!.contains(
                            RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ),
                          )
                              ? null
                              : "Please Enter a Valid Email",
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
                                    onPressed: () => setState(
                                      () => _emailController.clear(),
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
              )
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Okay, we just sent you a password reset email\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      TextSpan(
                        text: """
\nDid"t get it? Check your spam folder. If it"s not there, follow the tips in """,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: "our help docs.",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 18,
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
