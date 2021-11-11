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
  String _recommendationsString = "";

  @override
  void initState() {
    super.initState();

    List<String> hastagedList =
        widget._recommedations.map((rec) => "#$rec").toList();
    _recommendationsString = hastagedList.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 60,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              "Recommended",
              style: TextStyle(
                  color: Colors.green.withOpacity(1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "assets/fonts/OpenSans/OpenSans"),
            ),
          ),
          Expanded(
            child: Text(
              _recommendationsString,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
