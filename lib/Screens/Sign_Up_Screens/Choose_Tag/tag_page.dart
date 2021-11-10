import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Screens/Sign_Up_Screens/Choose_Tag/tags_list_and_colors.dart';
import '/Constants/colors.dart';
import '/Providers/followed_tags_sign_up.dart';
import '/Screens/Sign_Up_Screens/Choose_Tag/tag_container.dart';

class TagSelect extends StatefulWidget {
  const TagSelect({Key? key}) : super(key: key);

  @override
  _TagSelectState createState() => _TagSelectState();
}

class _TagSelectState extends State<TagSelect> {
  Widget appBar() {
    if (Provider.of<FollowedTags>(context).followedTags.length < 5)
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Pick ${5 - Provider.of<FollowedTags>(context).followedTags.length}",
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ));
    else
      return TextButton(
        onPressed: () {
          // Call Api Function to add all the chosen tags to his profile
        },
        child: const Center(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Next",
            style: TextStyle(
              fontSize: 15,
              color: Colors.blue,
            ),
          ),
        )),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(0, 21, 42, 1),
        actions: [
          appBar(),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: Text(
                "What do you like?",
                style: TextStyle(
                    fontSize: 27, color: Color.fromRGBO(200, 209, 216, 1)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: Text(
                "Whatever you're into, you'll find it here. Follow some of the tags below to start filling your dashboard with thing you love.",
                style: TextStyle(
                  fontSize: 19,
                  color: Color.fromRGBO(97, 111, 127, 1),
                ),
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              itemCount: tagsNames.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, i) {
                return TagContainer(index: i);
              },
            ),
          ],
        ),
      ),
    );
  }
}
