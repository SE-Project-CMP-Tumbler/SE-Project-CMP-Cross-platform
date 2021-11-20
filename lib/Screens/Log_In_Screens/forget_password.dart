import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tumbler/Methods/api.dart';

import '/Constants/colors.dart';
import '/Constants/ui_styles.dart';

class ForgetPassWord extends StatefulWidget {
  const ForgetPassWord({Key? key}) : super(key: key);

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
  void forgetPassword() async {
    Map<String, dynamic> response =
    await Api().forgetPassword(_emailController.text);

    if (response["meta"]["status"] == "200")
      setState(() => firstHomePage = false);
    else
      Fluttertoast.showToast(
          msg: response["meta"]["msg"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          title: const Image(
            image: AssetImage('assets/images/logo_letter.png'),
            height: 45,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate())
                  forgetPassword();
              },
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 15,
                        color: (_emailController.text.isEmpty)
                            ? Colors.blue.withOpacity(0.5)
                            : Colors.blue,
                      ),
                    ),
                  )),
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
            children: [
              const Text(
                "Forget your password? It happens.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "We'll send you a link to reset it.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    validator: (s) =>
                    s!.contains(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                        ? null
                        : "Please Enter a Valid Email",
                    controller: _emailController,
                    onChanged: (s) => setState(() {}),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: formEnabledFieldBorderStyle,
                      focusedBorder: formFocusedFieldBorderStyle,
                      hintStyle: const TextStyle(color: Colors.white30),
                      hintText: 'Email',
                      suffixIcon: _emailController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () =>
                            setState(
                                    () => _emailController.clear()),
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
              children: [
                TextSpan(
                  text: 'Okay, we just sent you a password reset email\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                TextSpan(
                  text:
                  '\nDid\'t get it? Check your spam folder. If it\'s not there, follow the tips in ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                  ),
                ),
                TextSpan(
                  text: 'our help docs.',
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
