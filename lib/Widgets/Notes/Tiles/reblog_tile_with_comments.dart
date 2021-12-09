import "package:flutter/material.dart";
import '../../Post/post_personal_avatar.dart';
import '../../Post/html_viewer.dart';


class ReblogTileWithComments extends StatelessWidget {
  
  ///
  const ReblogTileWithComments(
      {required final this.avatarUrl,
      required final this.userName,
      required final this.htmlData,
      required final this.avatarShape,
      final Key? key})
      : super(key: key);

  final String avatarUrl;
  final String userName;
  final String htmlData;
  final String avatarShape;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              PersonAvatar(avatarPhotoLink: avatarUrl, shape: avatarShape),
              const SizedBox(
                width: 5,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  userName,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ))
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          HtmlView(htmlData: htmlData),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Reblog",
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "View Post",
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                ),
              )
            ],
          ),
          const Divider(
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}

