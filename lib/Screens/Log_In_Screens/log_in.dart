import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tumbler/Methods/api.dart';
import 'package:tumbler/Models/users.dart';

import '/Constants/colors.dart';
import '/Constants/ui_styles.dart';
import '/Screens/Log_In_Screens/forget_password.dart';

class LogIN extends StatefulWidget {
  const LogIN({Key? key}) : super(key: key);

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

  form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              validator: (s) => s!.contains(RegExp(
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
              validator: (s) =>
                  s!.length < 8 ? "Please Enter Strong Password" : null,
              controller: _passController,
              onChanged: (s) => setState(() {}),
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  color: Colors.white,
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  icon: Icon(
                      (_obscureText) ? Icons.visibility : Icons.visibility_off),
                ),
                enabledBorder: formEnabledFieldBorderStyle,
                focusedBorder: formFocusedFieldBorderStyle,
                hintStyle: const TextStyle(color: Colors.white30),
                hintText: 'Password',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: appBackgroundColor,
      title: const Image(
        image: AssetImage('assets/images/logo_letter.png'),
        height: 45,
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              Map<String, dynamic> response = await Api()
                  .signIn(_emailController.text, _passController.text);

              // we should check other errors such as 404,500
              if (response.isNotEmpty) {
                User.name = response["blog_username"];
                User.email = response["email"];
                User.token = response["access_token"];
                User.id = response["id"];
                User.blogAvatar = response["blog_avatar"];
                // Navigate to Home Page
              } else {
                Fluttertoast.showToast(
                    msg: "Failed To Log In",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
          },
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
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
          )),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: form(),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgetPassWord(),
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
