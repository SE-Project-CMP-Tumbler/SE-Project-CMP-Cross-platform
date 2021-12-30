import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/get_all_blogs.dart";
import "package:tumbler/Methods/show_toast.dart";

/// a page for entering the new blog name
class CreateNewBlog extends StatefulWidget {
  /// constructor
  const CreateNewBlog({final Key? key}) : super(key: key);

  @override
  State<CreateNewBlog> createState() => _CreateNewBlogState();
}

class _CreateNewBlogState extends State<CreateNewBlog> {
  TextEditingController? _textEditingController;

  bool isValid() {
    return _textEditingController!.text.isNotEmpty;
  }

  /// post the blog
  Future<void> postBlog() async {
    if (isValid()) {
      final Map<String, dynamic> response =
          await Api().postNewBlog(_textEditingController!.text);

      if (response["meta"]["status"] == "200") {
        if (await fillUserBlogs()) {
          Navigator.of(context).pop();
          await showToast("Blog is Created");
        } else
          await showToast("Please try again later");
      } else
        await showToast(response["meta"]["msg"]);
    } else {
      await showToast("blog name is empty!");
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController!.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 1,
        title: const Text(
          "Create a new Tumbler",
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: postBlog,
            child: Text(
              "Save",
              style: TextStyle(
                color: floatingButtonColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/images/intro_3.jpg",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (final String val) {},
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: formEnabledFieldBorderStyle,
                      focusedBorder: formFocusedFieldBorderStyle,
                      hintText: "Name",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _textEditingController?.clear();
                },
                icon: const Icon(
                  CupertinoIcons.xmark,
                  color: Colors.white,
                ),
                constraints: const BoxConstraints(maxHeight: 28, minHeight: 28),
              )
            ],
          ),
        ),
      ),
    );
  }
}
