import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:tumbler/Models/post_model.dart";

/// to display random post images in the search page
class TryThesePosts extends StatelessWidget {
  /// constructor takes the url of the posts images
  const TryThesePosts({
    required final this.randomPosts,
    final Key? key,
  }) : super(key: key);

  /// the url of images extracted from the random posts
  final List<PostModel> randomPosts;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              "Try these posts",
              textScaleFactor: 1.4,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(kIsWeb ? 32 : 0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: kIsWeb ? 10 : 1,
                    mainAxisSpacing: kIsWeb ? 10 : 1,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: randomPosts.length < 10 ? randomPosts.length : 9,
                  itemBuilder: (final BuildContext context, final int index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Html(
                            data: randomPosts[index].postBody,
                            style: <String, Style>{
                              for (final String tag in Html.tags)
                                tag: Style(
                                  fontSize: FontSize.xLarge,
                                  backgroundColor: Colors.white,
                                  margin: EdgeInsets.zero,
                                  padding: tag == "h1"
                                      ? const EdgeInsets.only(top: 8, left: 4)
                                      : EdgeInsets.zero,
                                ),
                            },
                            tagsList: Html.tags..remove("video"),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
