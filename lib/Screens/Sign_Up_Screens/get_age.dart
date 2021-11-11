import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Models/users.dart';
import '/Screens/Sign_Up_Screens/Choose_Tag/tag_page.dart';
import '/Constants/colors.dart';

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBackgroundColor,
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  User.age = int.parse(_controller.text);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TagSelect()));
                }
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 15,
                    color: (_controller.text.isEmpty)
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.blue,
                  ),
                ),
              )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (s) => s!.contains(RegExp("^[0-9]*\$"))
                        ? (int.parse(s) >= 13 && int.parse(s) <= 130)
                            ? null
                            : "Please Enter age between 13 and 130"
                        : "Please Enter a Valid Number",
                    controller: _controller,
                    onChanged: (s) => setState(() {}),
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.blue,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white30),
                        hintText: 'How old are you?'),
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.justify,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'You\'re almost done. Enter your age, then tap the ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'NEXT',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: ' button to indicate that you\'ve read the ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: ' and agree to ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Service',
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
