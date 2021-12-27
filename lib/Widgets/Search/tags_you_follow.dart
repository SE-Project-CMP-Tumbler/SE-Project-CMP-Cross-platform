import "package:flutter/material.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Widgets/Search/tag_card.dart";

/// this is the tags section in the search screen
class TagsYouFollow extends StatelessWidget {
  /// constructor
  /// takes a list of tags backgrounds and the screen width
  const TagsYouFollow({
    required final this.tags,
    required final double width,
    final Key? key,
  })  : _width = width,
        super(key: key);

  /// a list of tags
  final List<Tag> tags;

  /// screen width
  final double _width;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// The title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Tags you follow",
                  textScaleFactor: 1.4,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Manage",
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),

          /// List of tags
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: tags
                    .map(
                      (final Tag item) => TagCard(
                        tag: item.tagDescription!,
                        tagBackGround: item.tagImgUrl!,
                        width: _width,
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
