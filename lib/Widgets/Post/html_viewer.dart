import "package:csslib/src/messages.dart";
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:simple_url_preview/simple_url_preview.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Screens/Profile/profile_page.dart";
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

  Future<void> extractMentionsTags(final String htmlBeforeProcessing) async {
    // Getting all mentions
    String html = htmlBeforeProcessing;
    int index1 = 0;
    int x = 0;
    while (x != -1 && index1 <= html.length - 5) {
      x = html.indexOf("@", index1);
      if (x != -1) {
        index1 = html.indexOf(" ", x);
        if (index1 == -1) {
          index1 = html.indexOf("<", x);
        }
        final String username = html.substring(x + 1, index1);

        final Map<String, dynamic> response = await Api().getUserInfo(username);
        if (response["meta"]["status"] == "200") {
          final String blogID = response["response"]["id"].toString();
          html = html.replaceRange(
            x,
            index1,
            "<a href='mention$blogID'>@$username</a>",
          );
          index1 += 13 + blogID.length;
        }
      }
    }

    index1 = 0;
    x = 0;
    while (x != -1 && index1 <= html.length - 5) {
      x = html.indexOf("#", index1);
      if (x != -1) {
        index1 = html.indexOf(" ", x);
        if (index1 == -1) {
          index1 = html.indexOf("<", x);
        }

        final String tag = html.substring(x, index1);
        html = html.replaceRange(x, index1, "<a href='tag'>$tag</a>");
        index1 += 10;
      }
    }

    setState(() => data = html);
  }

  @override
  void initState() {
    super.initState();
    data = widget.htmlData;
    extractMentionsTags(widget.htmlData);
  }

  @override
  Widget build(final BuildContext context) {
    return Html(
      data: data,
      style: <String, Style>{
        "table": Style(
          backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
        ),
        "p": Style(
          color: Colors.black,
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
          // maxLines: 2,
          // textOverflow: TextOverflow.ellipsis,
          // color: Colors.black,
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
        } else if (url == "tag") {
          // TODO(Ziyad): go to tag page
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
          if (herf == null || herf.startsWith("mention") || herf == "tag")
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
