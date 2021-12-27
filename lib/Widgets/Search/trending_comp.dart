import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:google_fonts/google_fonts.dart";
import "package:tumbler/Constants/colors.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";

/// the component of each trending tag
class TrendingComponent extends StatelessWidget {
  /// constructor takes a tag object
  const TrendingComponent({
    required final this.tag,
    required final this.index,
    required final this.posts,
    final this.numberColors = colors,
    final Key? key,
  }) : super(key: key);

  /// a single tag details
  final Tag tag;

  /// index of the trending
  final int index;

  ///
  final List<Color> numberColors;

  ///
  final List<PostModel> posts;

  ///
  static const List<Color> colors = <Color>[
    Color(0xff7F00FF),
    Color(0xffFF7BF5),
    Color(0xffFF5733),
    Color(0xffFFA440),
    Color(0xffF2FF40),
    Color(0xff00DF18),
    Color(0xff36BFFF),
    Color(0xff7F00FF),
    Color(0xffFF7BF5),
  ];

  @override
  Widget build(final BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 6),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: numberColors[index],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: GoogleFonts.publicSans(
                          color: navy,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        tag.tagDescription!,
                        textScaleFactor: 1.2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "#${tag.tagDescription!}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  "Follow",
                  textScaleFactor: 1.1,
                  style: TextStyle(
                    color: floatingButtonColor,
                  ),
                ),
              ),
            )
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 53),
            child: Row(
              children: posts
                  .map(
                    (final PostModel item) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3),
                        ),
                        child: Container(
                          width: _width / 4 + 10,
                          height: _width / 4 - 20,
                          color: Colors.white,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              child: Html(
                                data: item.postBody,
                                style: <String, Style>{
                                  for (final String tag in Html.tags)
                                    tag: Style(
                                      fontSize: FontSize.large,
                                      backgroundColor: Colors.white,
                                      margin: EdgeInsets.zero,
                                      padding: tag == "h1" || tag == "p"
                                          ? const EdgeInsets.only(left: 5)
                                          : EdgeInsets.zero,
                                      textOverflow: TextOverflow.ellipsis,
                                      width: _width / 4 + 20,
                                      height: _width / 4 - 20,
                                    ),
                                },
                                tagsList: Html.tags..remove("video"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
