import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/Providers/followed_tags_sign_up.dart';
import '/Screens/Sign_Up_Screens/Choose_Tag/add_your_own_tag.dart';
import '../Constants/tags_list_and_colors.dart';

class TagContainer extends StatefulWidget {
  final int index;

  const TagContainer({Key? key, required this.index}) : super(key: key);

  @override
  State<TagContainer> createState() => _TagContainerState();
}

class _TagContainerState extends State<TagContainer> {
  void pressed(bool x) {
    if (widget.index != 0) {
      if (x) {
        Provider.of<FollowedTags>(context, listen: false)
            .removeFollowTag(tagsNames[widget.index]);
      } else {
        Provider.of<FollowedTags>(context, listen: false)
            .addFollowTag(tagsNames[widget.index]);
      }
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AddYourOwnTag()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => pressed(context
          .read<FollowedTags>()
          .followedTags
          .contains(tagsNames[widget.index])),
      child: Stack(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AutoSizeText(
                  tagsNames[widget.index],
                  wrapWords: false,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            decoration: (widget.index == 0)
                ? BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(20)))
                : BoxDecoration(
              color: tagsColors[widget.index % tagsColors.length],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
          ),
          if (Provider.of<FollowedTags>(context)
              .followedTags
              .contains(tagsNames[widget.index]))
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.offline_pin),
              ),
            )
        ],
      ),
    );
  }
}
