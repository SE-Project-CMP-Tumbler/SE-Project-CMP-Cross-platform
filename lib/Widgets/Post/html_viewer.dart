import "package:csslib/src/messages.dart";
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:random_color/random_color.dart";
import "package:simple_url_preview/simple_url_preview.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/extract_mentions_tags.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/tag.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";
import "package:tumbler/Screens/Search/tag_posts.dart";
import "package:url_launcher/url_launcher.dart";

/// Used to render html content
class HtmlView extends StatefulWidget {
  /// takes html content as string.
  const HtmlView({
    required final this.htmlData,
    final Key? key,
  }) : super(key: key);

  /// HTML Data
  final String htmlData;

  @override
  State<HtmlView> createState() => _HtmlViewState();
}

class _HtmlViewState extends State<HtmlView> {
  String data = "";

  Future<void> initialize() async {
    data = await extractMentionsTags(widget.htmlData);
  }

  @override
  void initState() {
    super.initState();
    data = widget.htmlData;
    initialize();
  }

  @override
  Widget build(final BuildContext context) {
    return Html(
      data: data,
      style: <String, Style>{
        "table": Style(
          backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
        ),
        "tr": Style(
          border: const Border(bottom: BorderSide(color: Colors.grey)),
        ),
        "th": Style(
          padding: const EdgeInsets.all(6),
          backgroundColor: Colors.grey,
        ),
        "td": Style(
          padding: const EdgeInsets.all(6),
          alignment: Alignment.topLeft,
        ),
        "h5": Style(
          color: Colors.black,
        ),
        "h4": Style(
          color: Colors.black,
        ),
        "h3": Style(
          color: Colors.black,
        ),
        "h2": Style(
          color: Colors.black,
        ),
        "h1": Style(
          color: Colors.black,
        ),
        "img": Style(alignment: Alignment.center)
      },
      // ignore: always_specify_types
      customImageRenders: {
        (final Map<String, String> attr, final __) => attr["src"] != null:
            networkImageRender(width: 500, height: 300),
      },
      onLinkTap: (final String? url, final _, final __, final ___) async {
        if (url == null) {
          return;
        } else if (url.startsWith("mention")) {
          await Navigator.of(context).push(
            MaterialPageRoute<ProfilePage>(
              builder: (final BuildContext context) => ProfilePage(
                blogID: url.substring(7),
              ),
            ),
          );
        } else if (url.startsWith("tag")) {
          final Map<String, dynamic> response =
              await Api().fetchTagsDetails(url.substring(3));

          if (response["meta"]["status"] == "200") {
            await Navigator.push(
              context,
              MaterialPageRoute<TagPosts>(
                builder: (final BuildContext context) => TagPosts(
                  tag: Tag(
                    tagDescription: response["response"]["tag_description"],
                    tagImgUrl: response["response"]["tag_image"],
                    followersCount:
                        response["response"]["followers_number"] as int,
                    isFollowed:
                        (response["response"]["followed"] ?? false) as bool,
                    postsCount: response["response"]["posts_count"],
                  ),
                  bgColor: RandomColor().randomColor(),
                ),
              ),
            );
          } else
            await showToast(response["meta"]["msg"]);
        } else {
          if (await canLaunch(url))
            await launch(url);
          else
            await showToast("Cannot open this url");
        }
      },
      customRender: <String, dynamic Function(RenderContext, Widget)>{
        "a": (final RenderContext context, final Widget child) {
          final String? herf = context.tree.element?.attributes["href"];
          if (herf == null ||
              herf.startsWith("mention") ||
              herf.startsWith("tag"))
            return null;
          else
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                child,
                SimpleUrlPreview(
                  url: herf,
                  bgColor: Colors.transparent,
                  isClosable: false,
                  siteNameStyle: const TextStyle(color: Colors.red),
                  titleStyle: const TextStyle(color: Colors.black),
                ),
              ],
            );
        },
      },
      onImageTap: (final String? src, final _, final __, final ___) {
        //print(src);
      },
      onImageError: (final Object exception, final StackTrace? stackTrace) {
        //print(exception);
      },
      onCssParseError: (final String css, final List<Message> messages) {
        //print("css that error: $css");
        //print("error messages:");
        // for (var element in messages) {
        //   //print(element);
        // }
      },
    );
  }
}
