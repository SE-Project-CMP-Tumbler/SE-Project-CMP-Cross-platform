import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import '../../Methods/Api.dart';
import 'package:intl/intl.dart';
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
    Api().SendPost(processedHtml, "published", "general", postTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: FlatButton(
          onPressed: widget.isThisButtonDisabled ? null : addThePost,
          child: const Text("Post"),
          color: Colors.blue[400],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
    );
  }
}
