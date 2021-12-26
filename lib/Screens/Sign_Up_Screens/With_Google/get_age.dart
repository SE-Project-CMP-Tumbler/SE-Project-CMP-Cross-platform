import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/age_validation.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Sign_Up_Screens/With_Google/sign_up.dart";

/// Page To get The User Age
class GetAgeGoogle extends StatefulWidget {
  @override
  State<GetAgeGoogle> createState() => _GetAgeGoogleState();
}

class _GetAgeGoogleState extends State<GetAgeGoogle> {
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

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Age"),
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
                    "How old are you?",
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
                    validator: ageValidator,
                    controller: _controller,
                    onChanged: (final String s) => setState(() {}),
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.blue,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: formEnabledFieldBorderStyle,
                      focusedBorder: formFocusedFieldBorderStyle,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Enter your age, then tap the ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: "NEXT",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: " button to indicate that you've read the ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: " and agree to ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: "Terms of Service",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 100,
                  child: ElevatedButton(
                    onPressed: _controller.text.isEmpty
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              User.age = int.parse(_controller.text);
                              Navigator.of(context).push(
                                MaterialPageRoute<SignUpGoogle>(
                                  builder: (final BuildContext context) =>
                                      SignUpGoogle(),
                                ),
                              );
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
