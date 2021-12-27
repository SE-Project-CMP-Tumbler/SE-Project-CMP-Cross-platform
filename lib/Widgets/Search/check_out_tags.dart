import "package:flutter/material.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Widgets/Search/check_ou_tag.dart";
/// check out these tags section
class CheckOutTags extends StatelessWidget {
  /// constructor
  const CheckOutTags({
    required final double width,
    required final this.tagsToFollow,
    required final this.tagsBg,
    final Key? key,

  }) : _width = width, super(key: key);

  final double _width;
  /// tags photos
  final List<Tag> tagsToFollow;
  /// map of bg colors of tags
  final Map<Tag, Color> tagsBg;
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// title of the section
          const SizedBox(
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Check out these tags",
                textScaleFactor: 1.4,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          /// content of the section
          SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: tagsToFollow.isNotEmpty?tagsToFollow.map(
                        (final Tag item) =>
                      CheckOutTagComponent
                        (width: _width, tag: item, color: tagsBg[item]!,),)
                      .toList():<Widget>[Container()],


                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


