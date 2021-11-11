import 'package:flutter/material.dart';

class PostInteractionBar extends StatefulWidget {
  const PostInteractionBar({Key? key}) : super(key: key);

  @override
  _PostInteractionBarState createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "100 notes",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.favorite,
                  color: Colors.grey,
                )),
            const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.comment,
                  color: Colors.grey,
                )),
            const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.share,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}
