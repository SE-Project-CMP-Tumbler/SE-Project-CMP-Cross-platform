import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

///Used to render html content
class HtmlView extends StatelessWidget {
  final String htmlData;

  /// takes html content as string.
  const HtmlView({
    Key? key,
    required this.htmlData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: {
        "table": Style(
          backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
        ),
        'p': Style(
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
        'h5': Style(
          color: Colors.black,
          // maxLines: 2,
          // textOverflow: TextOverflow.ellipsis,
          // color: Colors.black,
        ),
        'h4': Style(
          color: Colors.black,
        ),
        'h3': Style(
          color: Colors.black,
        ),
        'h2': Style(
          color: Colors.black,
        ),
        'h1': Style(
          color: Colors.black,
        ),
        "img": Style(alignment: Alignment.center)
      },
      customImageRenders: {
        (attr, __) => attr["src"] != null:
            networkImageRender(width: 500, height: 300),
      },
      onLinkTap: (url, _, __, ___) {
        //print("opening $url");
      },
      onImageTap: (src, _, __, ___) {
        //print(src);
      },
      onImageError: (exception, stackTrace) {
        //print(exception);
      },
      onCssParseError: (css, messages) {
        //print("css that error: $css");
        //print("error messages:");
        // for (var element in messages) {
        //   //print(element);
        // }
      },
    );
  }
}
