import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/Constants/colors.dart';
import '/Constants/ui_styles.dart';
import '/Methods/api.dart';
import '/Models/users.dart';
import '/Screens/Log_In_Screens/log_in.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _nameController;
  late TextEditingController _passController;
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passController = TextEditingController();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: _nameController,
              onChanged: (s) => setState(() {}),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: formEnabledFieldBorderStyle,
                focusedBorder: formFocusedFieldBorderStyle,
                hintStyle: const TextStyle(color: Colors.white30),
                hintText: 'Name',
                suffixIcon: _nameController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () =>
                            setState(() => _nameController.clear()),
                        color: Colors.white30,
                      )
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: appBackgroundColor,
      actions: [
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              Map<String, dynamic> response = await Api().signUp(
                  _nameController.text,
                  _passController.text,
                  _emailController.text,
                  User.age);

              if (response["meta"]["status"] == "200") {
                User.name = response["response"]["blog_username"];
                User.email = response["response"]["email"];
                User.id = response["response"]["id"];
                User.blogAvatar = response["response"]["blog_avatar"];
                User.accessToken = response["response"]["access_token"];
                // TODO: Navigate to Home Page
              } else {
                Fluttertoast.showToast(
                  msg: response["meta"]["msg"],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            }
          },
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Done",
              style: TextStyle(
                fontSize: 15,
                color: (_nameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "What Should we call you?",
                  style: titleTextStyle,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
                  child: Text(
                    "You'll need a name to make your own posts, customize your blog, and message people.",
                    style: subTitleTextStyle,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: form(),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LogIN()));
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 19,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Text(
                          "Privacy dashboard",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
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
