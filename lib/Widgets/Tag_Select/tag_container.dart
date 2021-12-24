import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Constants/tags_list_and_colors.dart";
import "package:tumbler/Providers/followed_tags_sign_up.dart";
import "package:tumbler/Screens/Sign_Up_Screens/With_Email/Choose_Tag/add_your_own_tag.dart";

/// Custom Container for [TagSelect] page.
class TagContainer extends StatefulWidget {
  /// Constructor
  const TagContainer({required final this.index, final Key? key})
      : super(key: key);

  /// Index of the [TagContainer] in [TagSelect] page
  final int index;

  @override
  State<TagContainer> createState() => _TagContainerState();
}

class _TagContainerState extends State<TagContainer> {
  void pressed(final bool x) {
    if (widget.index != 0) {
      if (x) {
        Provider.of<FollowedTags>(context, listen: false)
            .removeFollowTag(tagsNames[widget.index]);
      } else {
        Provider.of<FollowedTags>(context, listen: false)
            .addFollowTag(tagsNames[widget.index]);
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<AddYourOwnTag>(
          builder: (final BuildContext context) => AddYourOwnTag(),
        ),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: () => pressed(
        context
            .read<FollowedTags>()
            .followedTags
            .contains(tagsNames[widget.index]),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: (widget.index == 0)
                ? BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  )
                : BoxDecoration(
                    color: tagsColors[widget.index % tagsColors.length],
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AutoSizeText(
                  tagsNames[widget.index],
                  wrapWords: false,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
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
