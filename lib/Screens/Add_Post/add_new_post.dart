import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:html_editor_enhanced/html_editor.dart";
import "package:intl/intl.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/process_html.dart";
import "package:tumbler/Models/user.dart";

/// Page to Add New Post
class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isPostButtonDisabled = true;
  final HtmlEditorController controller = HtmlEditorController();

  /// Return the Data in Custom Format
  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat("dd-MM-yyyy");
    final String formatted = formatter.format(now);
    return formatted;
  }

  Future<void> addThePost() async {
    final String html = await controller.getText();
    final String postTime = getDate();
    print("lol5");
    final String processedHtml = await extractMediaFiles(html);
    print("lol3");
    print(processedHtml);
    print("lol6");
    //final Map<String, dynamic> response = await
    Api().addPost(html, "published", "general", postTime);

    /*if (response["meta"]["status"] == "200") {
      await Fluttertoast.showToast(
        msg: "Added Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16,
      );
      Navigator.of(context).pop();
    } else {
      await Fluttertoast.showToast(
        msg: response["meta"]["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16,
      );
    }*/
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              // TODO(Salama): Alert to save as draft
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: isPostButtonDisabled ? null : addThePost,
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.blue[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Post"),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 0),
                ),
                height: MediaQuery.of(context).size.height * .05, //web hiz3l
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage("assets/images/profile_pic.png"),
                      ),
                    ),
                    Text(
                      User.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: "Add something, if you'd like",
                  shouldEnsureVisible: true,
                  mobileLongPressDuration: Duration(milliseconds: 500),
                  spellCheck: true,
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.belowEditor,
                  defaultToolbarButtons: <Toolbar>[
                    StyleButtons(),
                    FontSettingButtons(),
                    FontButtons(clearAll: false),
                    ColorButtons(),
                    ListButtons(),
                    ParagraphButtons(),
                    InsertButtons(),
                    OtherButtons(),
                  ],
                ),
                otherOptions: OtherOptions(
                  height: MediaQuery.of(context).size.height * .75, //web hiz3l
                ),
                callbacks: Callbacks(
                  onChangeContent: (final String? changed) async {
                    final String html = await controller.getText();
                    if (html.isEmpty) {
                      setState(() => isPostButtonDisabled = true);
                    } else {
                      setState(() => isPostButtonDisabled = false);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
