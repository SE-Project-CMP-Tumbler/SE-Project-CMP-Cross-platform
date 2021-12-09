import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:html_editor_enhanced/html_editor.dart";
import "package:intl/intl.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/process_html.dart";
import "../../Models/user.dart";
import "../../Widgets/Add_Post/dropdown_list.dart";
import "../../Widgets/Add_Post/popup_menu.dart";

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
    final String processedHtml = await extractMediaFiles(html);
    print(processedHtml);
    String postOptionChoice = "";
    if (postType == PostTypes.defaultPost) {
      postOptionChoice = "published";
    } else if (postType == PostTypes.draftPost) {
      postOptionChoice = "draft";
    } else if (postType == PostTypes.privatePost) {
      postOptionChoice = "private";
    }
    print("salama");
    final Map<String, dynamic> response =
        await Api().addPost(html, postOptionChoice, "general", postTime);
    print(response["meta"]["status"]);
    print("lollol");
    if (response["meta"]["status"] == "200") {
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
    }
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
              child: ElevatedButton(
                onPressed: isPostButtonDisabled ? null : addThePost,
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Post"),
              ),
            ),
            /*PopupMenuButton(
              
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (context) => [showModalBottomSheet(child: PostTypeMenu(), )],
            ),*/
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(mainAxisSize: MainAxisSize.min,
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //Divider(),
                          PostTypeMenu(),
                        ]);
                  },
                );
              },
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
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage("assets/images/profile_pic.png"),
                      ),
                    ),
                    ProfilesList(),
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
