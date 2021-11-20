import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:tumbler/Methods/api.dart';

import '../Methods/process_html.dart';

String getDate() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(now);
  return formatted;
}

class PostButton extends StatefulWidget {
  final HtmlEditorController controller;
  final bool isThisButtonDisabled;

  const PostButton(
      {required this.controller, required this.isThisButtonDisabled});

  @override
  _PostButtonState createState() => _PostButtonState();
}

class _PostButtonState extends State<PostButton> {
  void addThePost() async {
    String html = await widget.controller.getText();
    String postTime = getDate();
    String processedHtml = await extractMediaFiles(html);
    Map<String, dynamic> response =
        await Api().addPost(processedHtml, "published", "general", postTime);

    if (response["meta"]["status"] == "200") {
      Fluttertoast.showToast(
        msg: "Added Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
        msg: response["meta"]["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: widget.isThisButtonDisabled ? null : addThePost,
        child: const Text("Post"),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.blue[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
