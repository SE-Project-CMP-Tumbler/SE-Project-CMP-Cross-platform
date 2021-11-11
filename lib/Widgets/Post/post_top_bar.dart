import 'package:flutter/material.dart';

class PostTopBar extends StatefulWidget {
  const PostTopBar({Key? key}) : super(key: key);

  @override
  _PostTopBarState createState() => _PostTopBarState();
}

class _PostTopBarState extends State<PostTopBar> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: Colors.black,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PersonAvatar(),
          const Text(
            "IRON MAN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          FlatButton(
              onPressed: () {},
              child: const Text(
                "Follow",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              )),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child: const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.more_vert,
                color: Colors.amber,
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class PersonAvatar extends StatefulWidget {
  const PersonAvatar({Key? key}) : super(key: key);

  @override
  _PersonAvatarState createState() => _PersonAvatarState();
}

class _PersonAvatarState extends State<PersonAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0), //or 15.0
          child: Container(
            height: 40.0,
            width: 40.0,
            child: Image.network(
                "https://www.techinn.com/f/13806/138068257/hasbro-marvel-legends-iron-man-electronic-helmet.jpg"),
          ),
        ),
      ),
    );
  }
}
