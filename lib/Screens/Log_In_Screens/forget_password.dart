import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // call api function to send forget password email
                }
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
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
