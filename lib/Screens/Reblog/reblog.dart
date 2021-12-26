import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:html_editor_enhanced/html_editor.dart";
import "package:intl/intl.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/process_html.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Widgets/Add_Post/dropdown_list.dart";
import "package:tumbler/Widgets/Add_Post/popup_menu.dart";
import "package:tumbler/Widgets/Post/html_viewer.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

/// Page to Add New Post
class Reblog extends StatefulWidget {
  ///takes the html of the original post.
  const Reblog({required final this.originalPost});

  /// Html of the original post.
  final String originalPost;

  @override
  _ReblogState createState() => _ReblogState();
}

class _ReblogState extends State<Reblog> {
  bool isPostButtonDisabled = true;
  final HtmlEditorController controller = HtmlEditorController();

  Future<void> addThePost() async {
    final String html = await controller.getText();
    final String postTime = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final String processedHtml = await extractMediaFiles(html);
    String postOptionChoice = "";
    if (postType == PostTypes.defaultPost) {
      postOptionChoice = "published";
    } else if (postType == PostTypes.draftPost) {
      postOptionChoice = "draft";
    } else if (postType == PostTypes.privatePost) {
      postOptionChoice = "private";
    }

    final Map<String, dynamic> response = await Api()
        .addPost(processedHtml, postOptionChoice, "general", postTime);

    if (response["meta"]["status"] == "200") {
      await showToast("Added Successfully");
      Navigator.of(context).pop();
    } else {
      await showToast(response["meta"]["msg"]);
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
              // not completed in back end
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
                child: const Text("Reblog"),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (final BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        PostTypeMenu(),
                      ],
                    );
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
                height: MediaQuery.of(context).size.height * .06,
                child: Row(
                  children: <Widget>[
                    PersonAvatar(
                      avatarPhotoLink: User.avatars[User.currentProfile],
                      shape: User.avatarShapes[User.currentProfile],
                      blogID: User.blogsIDs[User.currentProfile],
                    ),
                    const ProfilesList(),
                  ],
                ),
              ),
              HtmlView(htmlData: widget.originalPost),
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
                    FontButtons(
                      clearAll: false,
                      strikethrough: false,
                      subscript: false,
                      superscript: false,
                    ),
                    InsertButtons(
                      hr: false,
                      table: false,
                    ),
                    ParagraphButtons(
                      caseConverter: false,
                      decreaseIndent: false,
                      increaseIndent: false,
                      lineHeight: false,
                      textDirection: false,
                    ),
                    FontSettingButtons(fontSizeUnit: false),
                  ],
                ),
                otherOptions: OtherOptions(
                  height: MediaQuery.of(context).size.height * .75,
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
