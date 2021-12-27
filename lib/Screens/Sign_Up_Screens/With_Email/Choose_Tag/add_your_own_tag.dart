import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Constants/tags_list_and_colors.dart";
import "package:tumbler/Constants/ui_styles.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Providers/followed_tags_sign_up.dart";

/// Page to add User's Own Tag
///
/// Will be used from [TagSelect] Page.
class AddYourOwnTag extends StatefulWidget {
  @override
  _AddYourOwnTagState createState() => _AddYourOwnTagState();
}

class _AddYourOwnTagState extends State<AddYourOwnTag> {
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;
  late List<String> _trending;

  Future<void> initializeTrending() async {
    final Map<String, dynamic> response = await
    Api().getTrendingTags();

    if (response["meta"]["status"] == "200") {
      final List<dynamic> json = response["response"]["tags"] as List<dynamic>;
      setState(
        () => _trending
            .addAll(json.map((final dynamic e) => e["tag_description"])),
      );
    } else {
      await showToast(response["meta"]["msg"]);
    }
  }

  @override
  void initState() {
    super.initState();
    _trending = <String>[];
    initializeTrending();
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
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBackgroundColor,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<FollowedTags>(context, listen: false)
                    .addFollowTag(_controller.text);
                if (!tagsNames.contains(_controller.text))
                  setState(() => tagsNames.insert(1, _controller.text));
                Navigator.pop(context);
              }
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Pick your own topics",
                style: titleTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Didn't find what you wanted? Add it below",
                style: subTitleTextStyle,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: 70,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (final String? s) =>
                      s!.isEmpty ? "Please add a tag" : null,
                  controller: _controller,
                  maxLength: 30,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    // should be with the color theme
                    prefixIcon: const Icon(Icons.add),
                    hintText: "Add Topic",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Trending",
                style: TextStyle(
                  fontSize: 27,
                  color: Color.fromRGBO(200, 209, 216, 1),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _trending.length,
              itemBuilder: (final BuildContext context, final int i) {
                return ListTile(
                  onTap: () {
                    Provider.of<FollowedTags>(context, listen: false)
                        .addFollowTag(_trending[i]);
                    if (!tagsNames.contains(_trending[i]))
                      setState(() => tagsNames.insert(1, _trending[i]));
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  dense: true,
                  title: Text(
                    _trending[i],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(200, 209, 216, 1),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
