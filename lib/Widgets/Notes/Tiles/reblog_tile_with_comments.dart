// ignore_for_file: public_member_api_docs

import "package:flutter/material.dart";
import "package:tumbler/Widgets/Post/html_viewer.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

class ReblogTileWithComments extends StatelessWidget {
  ///
  const ReblogTileWithComments({
    required final this.avatarUrl,
    required final this.userName,
    required final this.htmlData,
    required final this.avatarShape,
    final Key? key,
  }) : super(key: key);

  final String avatarUrl;
  final String userName;
  final String htmlData;
  final String avatarShape;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              PersonAvatar(avatarPhotoLink: avatarUrl, shape: avatarShape),
              const SizedBox(
                width: 2,
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
                    icon: const Icon(Icons.more_horiz),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          HtmlView(htmlData: htmlData),
          Row(
            children: <Widget>[
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
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
