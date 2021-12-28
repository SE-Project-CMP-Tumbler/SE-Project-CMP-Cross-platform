import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Providers/tags.dart";
import "package:tumbler/Widgets/Search/trending_comp.dart";

/// to show trendings tags
class Trending extends StatefulWidget {
  /// constructor takes a list of trending tags
  const Trending({
    required final this.trendingTags,
    required final this.tagPosts,
    final Key? key,
  }) : super(key: key);

  /// list of trending tags
  final List<Tag> trendingTags;

  /// map of each tag with its posts
  final Map<Tag, List<PostModel>> tagPosts;

  @override
  State<Trending> createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Trending now",
              textScaleFactor: 1.4,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (Provider.of<Tags>(context,listen: false).isLoaded==false&&
              widget.trendingTags.isEmpty)const Center(
                child:
          CircularProgressIndicator(),
              ) else Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.trendingTags
                .map(
                  (final Tag item) => TrendingComponent(
                    key: Key(item.tagDescription!),
                    tag: item,
                    index: widget.trendingTags.indexOf(item),
                    posts: widget.tagPosts[item] ?? <PostModel>[],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
