import 'package:flutter/material.dart';

class PostRecommendationBar extends StatefulWidget {
  final _recommedations = [
    'games',
    'movies',
    'entertainment',
    'marvel',
    'studio',
    'iron man',
    'super power'
  ];

  //PostRecommendationBar(this._recommedations);

  @override
  _PostRecommendationBarState createState() => _PostRecommendationBarState();
}

class _PostRecommendationBarState extends State<PostRecommendationBar> {
  List<TextSpan> textSpans = <TextSpan>[];

  @override
  void initState() {
    super.initState();
    textSpans = widget._recommedations
        .map((word) => TextSpan(
              text: "#$word ",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Colors.black12,
      height: 60,
      child: Row(children: [
        Expanded(
          child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: 'Recommended ',
                style: TextStyle(
                    color: Colors.green.withOpacity(1),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: "assets/fonts/OpenSans/OpenSans"),
                children: textSpans,
              )),
        )
      ]),
    );
  }
}
