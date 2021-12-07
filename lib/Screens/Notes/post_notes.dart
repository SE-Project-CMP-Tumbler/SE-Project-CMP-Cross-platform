import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../Methods/api.dart";

class Notes extends StatefulWidget {
  Notes(
      {Key? key,
      required this.likes,
      required this.reblogs,
      required this.replies})
      : super(key: key);

  List<dynamic> likes = <dynamic>[];
  List<dynamic> reblogs = <dynamic>[];
  List<dynamic> replies = <dynamic>[];

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 25, 53, 1),
          titleSpacing: 0,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                  "${numFormatter.format(widget.likes.length + widget.replies.length + widget.reblogs.length)} notes"),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    alignment: Alignment.centerRight,
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded),
                    iconSize: 30,
                  ),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            tabs: <Widget>[
              CustomizedTab(
                iconType: Icons.comment,
                number: widget.replies.length,
              ),
              CustomizedTab(
                iconType: Icons.repeat,
                number: widget.reblogs.length,
              ),
              CustomizedTab(
                iconType: Icons.favorite_outline_outlined,
                number: widget.likes.length,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                itemBuilder: (final BuildContext ctx, final int index) {
                  return Reply(
                    commentText: widget.replies[index]["reply_text"],
                    userName: widget.replies[index]["blog_username"],
                    photoUrl:  widget.replies[index]["blog_avatar"],
                  );
                },
                itemCount: widget.replies.length,
              ),
            ),
            const Center(
              child: Text("reblogs here"),
            ),
            const Center(
              child: Text("favorites here"),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomizedTab extends StatelessWidget {
  CustomizedTab({
    Key? key,
    required this.number,
    required this.iconType,
  }) : super(key: key);

  final int number;
  final IconData iconType;

  NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconType),
            const SizedBox(
              width: 5,
            ),
            Text(numFormatter.format(number)),
          ],
        ),
      ),
    );
  }
}

class Reply extends StatelessWidget {
  Reply(
      {Key? key,
      required this.photoUrl,
      required this.userName,
      required this.commentText})
      : super(key: key);

  final String photoUrl;
  final String userName;
  final String commentText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(photoUrl),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      commentText,
                      maxLines: 1000,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
