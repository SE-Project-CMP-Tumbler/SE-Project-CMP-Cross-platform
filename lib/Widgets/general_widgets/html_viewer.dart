import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// This widget can
/*

1- show text with style
2- show images

*/

class HtmlView extends StatelessWidget {
  String htmlData = "";
  HtmlView({
    Key? key,
    required this.htmlData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: {
        "table": Style(
          backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
        ),
        "tr": Style(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        "th": Style(
          padding: EdgeInsets.all(6),
          backgroundColor: Colors.grey,
        ),
        "td": Style(
          padding: EdgeInsets.all(6),
          alignment: Alignment.topLeft,
        ),
        'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
        "img":Style( alignment: Alignment.center)
      },
      customImageRenders: {
        (attr, __) => attr["src"] != null: networkImageRender(width: 500, height: 300),
      },
      onLinkTap: (url, _, __, ___) {
        print("opening $url");
      },
      onImageTap: (src, _, __, ___) {
        print(src);
      },
      onImageError: (exception, stackTrace) {
        print(exception);
      },
      onCssParseError: (css, messages) {
        print("css that errored: $css");
        print("error messages:");
        messages.forEach((element) {
          print(element);
        });
      },
    );
  }
}
