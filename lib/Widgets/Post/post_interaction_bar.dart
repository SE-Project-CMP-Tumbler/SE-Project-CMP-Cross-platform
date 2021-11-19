import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class PostInteractionBar extends StatefulWidget {
  int notesNum;
  PostInteractionBar({Key? key, required this.notesNum}) : super(key: key);

  @override
  _PostInteractionBarState createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  bool isLoved = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 60,
            child: FlatButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onPressed: () {},
                child: Image.asset(
                  'assets/images/interactions.jpeg',
                )),
          ),
          Expanded(
            child: Text(
              '${widget.notesNum} notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.reply,
                color: Colors.black,
              )),
          const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.repeat,
                color: Colors.black,
              )),
          LikeButton(
            isLiked: isLoved,
            likeBuilder: (isLoved) {
              final color = (isLoved) ? Colors.red : Colors.black;
              return Icon(
                (isLoved) ? Icons.favorite : Icons.favorite_border_outlined,
                color: color,
              );
            },
          ),
          const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.add_comment_outlined,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
