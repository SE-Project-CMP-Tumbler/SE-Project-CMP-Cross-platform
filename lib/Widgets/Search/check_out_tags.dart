import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Providers/tags.dart";
import "package:tumbler/Widgets/Search/check_ou_tag.dart";
/// check out these tags section
class CheckOutTags extends StatefulWidget {
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
  State<CheckOutTags> createState() => _CheckOutTagsState();
}

class _CheckOutTagsState extends State<CheckOutTags> {
  ScrollController? _controller;
  List<Tag> _tagsToFollow=<Tag> [];

  @override
  void initState() {
    _controller= ScrollController();
    _tagsToFollow= widget.tagsToFollow;
    super.initState();
  }
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
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
            child:
          (Provider.of<Tags>(context,listen: false).isLoaded==false&&
              widget.tagsToFollow.isEmpty)?
          const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child:  Row(
                  children: widget.tagsToFollow.isNotEmpty?
                  widget.tagsToFollow.map(
                        (final Tag item) =>
                        CheckOutTagComponent
                          (width: widget._width, tag: item,
                          color: widget.tagsBg[item]!,
                          isFollowed: item.isFollowed!,
                          key: Key(item.tagDescription!),
                        ),)
                      .toList()
                      :<Widget>[Container()],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}


