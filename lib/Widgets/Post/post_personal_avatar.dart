import 'package:flutter/material.dart';


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
          borderRadius: BorderRadius.circular(10.0), 
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