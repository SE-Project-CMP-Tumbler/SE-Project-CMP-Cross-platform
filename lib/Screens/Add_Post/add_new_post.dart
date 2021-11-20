import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../Widgets/post_button.dart';

AssetImage profilePic = const AssetImage('assets/images/profile_pic.png');
String userName = "UserName";

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isPostButtonDisabled = true;
  final HtmlEditorController controller =
      HtmlEditorController(processOutputHtml: true);

  @override
  Widget build(BuildContext context) {
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
                  // TODO: Alert to save as draft
                  Navigator.of(context).pop();
                }),
            actions: [
              PostButton(
                  controller: controller,
                  isThisButtonDisabled: isPostButtonDisabled)
            ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 0)),
                height: MediaQuery.of(context).size.height * .05, //web hiz3l
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: profilePic,
                      ),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: 'Add something, if you\'d like',
                  shouldEnsureVisible: true,
                  autoAdjustHeight: true,
                  adjustHeightForKeyboard: true,
                  mobileLongPressDuration: Duration(milliseconds: 500),
                  spellCheck: true,
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.belowEditor,
                  toolbarType: ToolbarType.nativeScrollable,
                ),
                otherOptions: OtherOptions(
                  height: MediaQuery.of(context).size.height * .75, //web hiz3l
                ),
                callbacks: Callbacks(
                  onChangeContent: (String? changed) async {
                    String txt = await controller.getText();
                    if (txt.isEmpty) {
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
