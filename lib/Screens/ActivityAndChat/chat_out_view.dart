import "package:flutter/material.dart";


import 'dart:convert';
import 'package:flutter/material.dart';
import "package:tumbler/Widgets/Add_Post/dropdown_list.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";
import 'package:tumbler/Methods/api.dart';
import "package:tumbler/Models/chat.dart";
import "package:tumbler/Models/http_requests_exceptions.dart";
import 'package:tumbler/Widgets/Post/post_personal_avatar.dart';


//////////////////////////////////////////////////////////////////////////////////
String photo3 =
    "https://scontent.fcai21-4.fna.fbcdn.net/v/t1.6435-9/59666375_1632018636942300_2475845812018479104_n.jpg?_nc_cat=109&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeFvz-iGY3CMgw88boHa4Jaa1EVb58kTLCfURVvnyRMsJ7KEGI1mrisQ_rQIhM--scneT9FFjW6EdRAC1A4iN299&_nc_ohc=wYTbxZBUdPQAX8cO7E9&tn=m_xBMswk-EGUIA-5&_nc_ht=scontent.fcai21-4.fna&oh=00_AT-Vv-8LBc3_ADWt-C5Tgj5rHKlURHkNXa-ApbsEKwCsfQ&oe=61E8BBC5";
String photo2 =
    "https://scontent.fcai21-4.fna.fbcdn.net/v/t39.30808-6/246464901_4452251418223292_1084624097520561268_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeHczCde1PZat8WK0Yzbr8wDjEWaEGZ2cemMRZoQZnZx6f07q_934cUjOi6P9c-GJt7fyFNcod0KOKIreH6Gn3lF&_nc_ohc=npNWpywkKnEAX9b68HK&_nc_ht=scontent.fcai21-4.fna&oh=00_AT-_l5RqcupfMLqWj6f41HaY6wwCFm6fU2Rr46YSRk5SiA&oe=61C9ED75";
String photo1 =
    "https://deadline.com/wp-content/uploads/2020/11/Stephen-Lang-Headshot-Matt-Sayles-e1605093774374.jpg";
//Chat(this.last_message, this.photo, this.blog_id, this.blog_username,
// this.blog_avatar, this.blog_avatar_shape, this.blog_title);
List<Chat> chats = [
  Chat("salam now", "", 15, "el7ag abbas", photo1, "", "", true),
  Chat("gmadan", "", 13, "Waleed", photo2, "", "", false),
  Chat("<3", "", 12, "Ziyad Hassan", photo3, "", "", true),
  Chat("a5oia", "", 12, "El-NeBo",
      "https://avatars.githubusercontent.com/u/62252633?v=4", "", "", true),
];
void loadChats() async {
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
  final dynamic response = await Api().getChats();
  final List<dynamic> chatsList = encodedRes["response"]["chat_messages"];
  for (int i = 0; i < chatsList.length; i++) {
    chats.add(
      Chat(
        chatsList[i]["text"],
        chatsList[i]["photo"],
        chatsList[i]["blog_id"] as int,
        chatsList[i]["blog_username"],
        chatsList[i]["blog_avatar"],
        chatsList[i]["blog_avatar_shape"],
        chatsList[i]["blog_title"],
        chatsList[i]["read"] as bool,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////


class ChatOutView extends StatefulWidget {
  const ChatOutView({Key? key}) : super(key: key);

  @override
  _ChatOutViewState createState() => _ChatOutViewState();
}

class _ChatOutViewState extends State<ChatOutView> {

  _buildChat(Chat chat) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print(chat.blog_username);
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
