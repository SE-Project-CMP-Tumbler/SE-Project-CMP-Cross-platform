import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Screens/Search/search_query.dart";

///  This is the search header , it contains
///  the randomly changed background and the search bar
class SearchHeader extends StatelessWidget {
  /// constructor
  /// takes the random background image url
  /// and the state variable (isExpanded) to indicate
  /// if the user scrolled the page or not
  const SearchHeader({
    required final double height,
    required final double width,
    required final this.backGround,
    required final this.isExpanded,
    required final this.recommendedTags,
    final Key? key,
  })  : _height = height,
        _width = width,
        super(key: key);

  final double _height;
  final double _width;

  /// backGrounds to display
  final String backGround;

  /// to indicate whether the app is scrolled or not
  final bool isExpanded;

  /// a list of recommended tags to be used a recommended words to search about
  final List<Tag> recommendedTags;

  @override
  Widget build(final BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      expandedHeight: _height * 0.26,
      flexibleSpace: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              width: _width,
              decoration: BoxDecoration(
                color: navy,
                image: DecorationImage(
                  image: NetworkImage(
                    backGround,
                  ),
                  fit: BoxFit.cover,
                ),
                border: Border.all(width: 0),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 16,
                    right: 16,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<SearchQuery>(
                          builder: (final BuildContext context) => SearchQuery(
                            recommendedTags: recommendedTags,
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 300),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      width: isExpanded ? _width * 0.7 : _width,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.search,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Search Tumbler",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
