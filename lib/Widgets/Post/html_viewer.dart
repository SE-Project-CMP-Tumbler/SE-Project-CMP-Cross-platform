import "package:csslib/src/messages.dart";
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";

String process(final String htmlBeforeProcessing) {
  // Getting all images
  String html = htmlBeforeProcessing;
  int index1 = 0;
  int x = 0;
  while (x != -1 && index1 <= html.length - 5) {
    x = html.indexOf("@", index1);
    if (x != -1) {
      index1 = html.indexOf(" ", x);
      if (index1 == -1)
        index1 = html.indexOf("<", x);

      final String mention = html.substring(x,index1);
      html = html.replaceRange(x, index1, "<a href='post'>$mention</a>");
      index1 += 18;
    }
  }

  return html;
}

/// Used to render html content
class HtmlView extends StatelessWidget {
  /// takes html content as string.
  const HtmlView({
    required final this.htmlData,
    final Key? key,
  }) : super(key: key);

  /// HTML Data
  final String htmlData;

  @override
  Widget build(final BuildContext context) {
    return Html(
      data: process(htmlData),
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
      onLinkTap: (final String? url, final _, final __, final ___) {
        print("link is clicked");
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
