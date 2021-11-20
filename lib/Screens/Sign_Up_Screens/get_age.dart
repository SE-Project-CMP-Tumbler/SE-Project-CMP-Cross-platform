import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/age_validation.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Sign_Up_Screens/Choose_Tag/tag_page.dart";

/// Page To get The User Age
class GetAge extends StatefulWidget {
  @override
  State<GetAge> createState() => _GetAgeState();
}

class _GetAgeState extends State<GetAge> {
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
          backgroundColor: appBackgroundColor,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  User.age = int.parse(_controller.text);
                  Navigator.of(context).push(
                    MaterialPageRoute<TagSelect>(
                      builder: (final BuildContext context) => TagSelect(),
                    ),
                  );
                }
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 15,
                      color: (_controller.text.isEmpty)
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
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
                      hintStyle: const TextStyle(color: Colors.white30),
                      hintText: "How old are you?",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            "You're almost done. Enter your age, then tap the ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "NEXT",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: " button to indicate that you've read the ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: " and agree to ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "Terms of Service",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
