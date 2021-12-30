import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:html_editor_enhanced/html_editor.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/process_html.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Widgets/Add_Post/dropdown_list.dart";
import "package:tumbler/Widgets/Post/html_viewer.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

/// Type of Post
enum PostTypes {
  /// Default Post type (Reblog)
  defaultPost,

  /// When Saved as Draft
  draftPost,

  /// When Posted as private
  privatePost
}

/// Page to Add New Post
class Reblog extends StatefulWidget {
  ///takes the html of the original post.
  const Reblog({
    required final this.originalPost,
    required final this.parentPostId,
  });

  /// Html of the original post.
  final String originalPost;

  /// parent post id
  final String parentPostId;

  @override
  _ReblogState createState() => _ReblogState();
}

class _ReblogState extends State<Reblog> {
  final HtmlEditorController controller = HtmlEditorController();
  String postButtonText = "Reblog";

  /// the current post type
  PostTypes postType = PostTypes.defaultPost;

  Future<void> addTheReblog() async {
    final String html = await controller.getText();
    final String processedHtml = await extractMediaFiles(html);
    String postOptionChoice = "";
    if (postType == PostTypes.defaultPost) {
      postOptionChoice = "published";
    } else if (postType == PostTypes.draftPost) {
      postOptionChoice = "draft";
    } else if (postType == PostTypes.privatePost) {
      postOptionChoice = "private";
    }

    final Map<String, dynamic> response = await Api().reblog(
      User.blogsIDs[User.currentProfile],
      widget.parentPostId,
      processedHtml,
      postOptionChoice,
      "general",
    );

    if (response["meta"]["status"] == "200") {
      await showToast("Rebloged Successfully");
      Navigator.of(context).pop();
    } else {
      await showToast(response["meta"]["msg"]);
    }
  }

  Widget postTypeMenu() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text(
                "                  Post options     ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.blue[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Done"),
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 0.4,
          color: Colors.black45,
        ),
        ListTile(
          onTap: () {
            setState(() {
              postButtonText = "Reblog";
              postType = PostTypes.defaultPost;
            });
            Navigator.of(context).pop();
          },
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.post_add,
                color: Colors.black,
              ),
              Text("   Reblog"),
            ],
          ),
          trailing: Radio<PostTypes>(
            value: PostTypes.defaultPost,
            groupValue: postType,
            onChanged: (final PostTypes? value) {
              setState(() {
                postButtonText = "Post";
                postType = value!;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
        const Divider(
          thickness: 0.3,
          color: Colors.black45,
        ),
        ListTile(
          onTap: () {
            setState(() {
              postButtonText = "Save draft";
              postType = PostTypes.draftPost;
            });
            Navigator.of(context).pop();
          },
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.save,
                color: Colors.black,
              ),
              Text("   Save as draft"),
            ],
          ),
          trailing: Radio<PostTypes>(
            value: PostTypes.draftPost,
            groupValue: postType,
            onChanged: (final PostTypes? value) {
              setState(() {
                postButtonText = "Save draft";
                postType = value!;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
        const Divider(
          thickness: 0.32,
          color: Colors.black45,
        ),
        ListTile(
          onTap: () {
            setState(() {
              postButtonText = "Post Privately";
              postType = PostTypes.privatePost;
            });
            Navigator.of(context).pop();
          },
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.lock,
                color: Colors.black,
              ),
              Text("   Post privately"),
            ],
          ),
          trailing: Radio<PostTypes>(
            value: PostTypes.privatePost,
            groupValue: postType,
            onChanged: (final PostTypes? value) {
              setState(() {
                postButtonText = "Post privately";
                postType = value!;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
        const Divider(
          thickness: 0.32,
          color: Colors.black45,
        ),
      ],
    );
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
                onPressed: addTheReblog,
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(postButtonText),
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
                      children: <Widget>[
                        postTypeMenu(),
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
              Container(
                height: 2,
                color: Colors.black,
              ),
              HtmlView(htmlData: widget.originalPost),
              Container(
                height: 2,
                color: Colors.black,
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
                  onChangeContent: (final String? changed) async {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
