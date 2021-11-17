import 'package:flutter/material.dart';

class PostInteractionBar extends StatefulWidget {
  int notesNum;
  PostInteractionBar({Key? key, required this.notesNum}) : super(key: key);

  @override
  _PostInteractionBarState createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
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
                  Icons.share,
                  color: Colors.black,
                )),
            const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.repeat,
                  color: Colors.black,
                )),
            const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
