import "package:flutter/material.dart";
import "../Chat/inside_chat.dart";
import 'dart:convert';
import 'package:flutter/material.dart';
import "package:tumbler/Widgets/Add_Post/dropdown_list.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";
import 'package:tumbler/Methods/api.dart';
import "package:tumbler/Models/chat.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import 'package:tumbler/Widgets/Post/post_personal_avatar.dart';

//////////////////////////////////////////////////////////////////////////////////


List<Chat> chats = [
];
Future<void> loadChats() async {
  // clear all loaded post.
  final dynamic res = await Api().getChats();
  print(res.body);
  //checking the status code of the received response.
  if (res.statusCode == 401)
    throw HttpException("You are not authorized");
  else if (res.statusCode == 404) {
    throw HttpException("Not Found!");
  }
  chats.clear();
  final Map<String, dynamic> encodedRes = jsonDecode(res.body);
  final List<dynamic> chatsList = encodedRes["response"]["chat_messages"];
  for (int i = 0; i < chatsList.length; i++) {
    String chk = chatsList[i]["from_blog_id"].toString();
    if (chk == User.blogsIDs[User.currentProfile]) {
      chats.add(
        Chat(
          chatsList[i]["text"],
          "",
          chatsList[i]["friend_blog_id"] as int,
          chatsList[i]["friend_blog_username"],
          chatsList[i]["friend_blog_avatar"],
          "",
          "",
          chatsList[i]["read"] as bool,
        ),
      );
    } else {
      chats.add(
        Chat(
          chatsList[i]["text"] ,
          "",
          chatsList[i]["from_blog_id"] as int,
          chatsList[i]["from_blog_username"],
          chatsList[i]["from_blog_avatar"],
          "",
          "",
          chatsList[i]["read"] as bool,
        ),
      );
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class ChatOutView extends StatefulWidget {
  const ChatOutView({Key? key}) : super(key: key);

  @override
  _ChatOutViewState createState() => _ChatOutViewState();
}

class _ChatOutViewState extends State<ChatOutView> {
  @override
  void initState() {
    super.initState();
    loadChats().then((res) {
      print(chats);
      setState(() {});
    });
    // print(chats);
    // setState(() {});
  }

  _buildChat(Chat chat) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print(chat.blog_username);
            Navigator.of(context).push(
              MaterialPageRoute<ChatScreen>(
                builder: (final BuildContext context) =>
                    ChatScreen(chat.blog_id.toString()),
              ),
            );
          },
          child: Row(
            children: [
              PersonAvatar(
                avatarPhotoLink: chat.blog_avatar,
                shape: chat.blog_avatar_shape,
                blogID: chat.blog_id.toString(),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    chat.read
                        ? Row(children: [
                            Text(
                              chat.blog_username,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ])
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                  chat.blog_username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ]),
                    Row(
                      children: [Text(chat.last_message)],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Divider(
            //height: 10,
            thickness: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 15.0),
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          final chat = chats[index];

          return _buildChat(chat);
        },
      ),
    );
  }
}
