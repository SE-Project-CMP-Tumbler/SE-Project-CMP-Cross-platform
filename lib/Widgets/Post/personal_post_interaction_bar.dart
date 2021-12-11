import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:like_button/like_button.dart";

/// same as post interaction bar but with som additional features
class PersonalPostInteractionBar extends StatefulWidget {
  /// constructor, takes the notes number
  const PersonalPostInteractionBar({
    required final this.notesNum,
    final Key? key,
  }) : super(key: key);

  /// count of notes to display on the post
  final int? notesNum;

  @override
  _PersonalPostInteractionBarState createState() =>
      _PersonalPostInteractionBarState();
}

class _PersonalPostInteractionBarState
    extends State<PersonalPostInteractionBar> {
  bool isLoved = false;
  NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: Text(
                "${numFormatter.format(widget.notesNum)} notes",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black45,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    CupertinoIcons.arrowshape_turn_up_right,
                    color: Colors.grey.shade800,
                  ),
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    CupertinoIcons.conversation_bubble,
                    color: Colors.grey.shade800,
                  ),
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.repeat,
                    color: Colors.grey.shade800,
                  ),
                  iconSize: 20,
                ),
                LikeButton(
                  isLiked: isLoved,
                  likeBuilder: (final bool isLoved) {
                    final Color color =
                        isLoved ? Colors.red : Colors.grey.shade800;
                    return Icon(
                      isLoved ? Icons.favorite : Icons.favorite_border_outlined,
                      color: color,
                      size: 20,
                    );
                  },
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    CupertinoIcons.trash,
                    color: Colors.grey.shade800,
                  ),
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.grey.shade800,
                  ),
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
