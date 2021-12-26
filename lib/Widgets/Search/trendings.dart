import "package:flutter/material.dart";
import "package:tumbler/Models/post.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Widgets/Search/trending_comp.dart";
/// to show trendings tags
class Trending extends StatelessWidget {
  /// constructor takes a list of trending tags
  const Trending({
    required final this.trendingTags,
    required final this.tagPosts,
    final Key? key,
  }) : super(key: key);

  /// list of trending tags
  final List<Tag> trendingTags;

  /// map of each tag with its posts
  final Map<Tag, List<Post>> tagPosts;
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Trending now",
              textScaleFactor: 1.4,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: trendingTags.map((final Tag item) =>
                TrendingComponent(
                  tag: item,
                  index: trendingTags.indexOf(item),
                  posts:tagPosts[item]??<Post>[],),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}

