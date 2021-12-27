import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/chat.dart";
import "package:tumbler/Widgets/Add_Post/dropdown_list.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

/// Chat Page
class Chats extends StatefulWidget {
  /// Constructor
  const Chats({final Key? key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

String photo3 =
    "https://scontent.fcai21-4.fna.fbcdn.net/v/t1.6435-9/59666375_1632018636942300_2475845812018479104_n.jpg?_nc_cat=109&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeFvz-iGY3CMgw88boHa4Jaa1EVb58kTLCfURVvnyRMsJ7KEGI1mrisQ_rQIhM--scneT9FFjW6EdRAC1A4iN299&_nc_ohc=wYTbxZBUdPQAX8cO7E9&tn=m_xBMswk-EGUIA-5&_nc_ht=scontent.fcai21-4.fna&oh=00_AT-Vv-8LBc3_ADWt-C5Tgj5rHKlURHkNXa-ApbsEKwCsfQ&oe=61E8BBC5";
String photo2 =
    "https://scontent.fcai21-4.fna.fbcdn.net/v/t39.30808-6/246464901_4452251418223292_1084624097520561268_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeHczCde1PZat8WK0Yzbr8wDjEWaEGZ2cemMRZoQZnZx6f07q_934cUjOi6P9c-GJt7fyFNcod0KOKIreH6Gn3lF&_nc_ohc=npNWpywkKnEAX9b68HK&_nc_ht=scontent.fcai21-4.fna&oh=00_AT-_l5RqcupfMLqWj6f41HaY6wwCFm6fU2Rr46YSRk5SiA&oe=61C9ED75";
String photo1 =
    "https://deadline.com/wp-content/uploads/2020/11/Stephen-Lang-Headshot-Matt-Sayles-e1605093774374.jpg";
//Chat(this.last_message, this.photo, this.blog_id, this.blog_username,
// this.blog_avatar, this.blog_avatar_shape, this.blog_title);
List<Chat> chats = <Chat>[
  Chat("salam now", "", 15, "el7ag abbas", photo1, "", "", true),
  Chat("gmadan", "", 13, "Waleed", photo2, "", "", false),
  Chat("<3", "", 12, "Ziyad Hassan", photo3, "", "", true),
  Chat(
    "a5oia",
    "",
    12,
    "El-NeBo",
    "https://avatars.githubusercontent.com/u/62252633?v=4",
    "",
    "",
    true,
  ),
];

Future<void> loadChats() async {
  // clear all loaded post.
  final Map<String, dynamic> response = await Api().getChats();
  //checking the status code of the received response.
  if (response["meta"]["status"] == "200") {
    chats.clear();
    final List<dynamic> chatsList = response["response"]["chat_messages"];
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
  } else
    await showToast(response["meta"]["msg"]);
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    super.initState();

    //setState(() => loadChats());
  }

  Widget _buildChat(final Chat chat) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            // print(chat.blogUsername);
          },
          child: Row(
            children: <Widget>[
              PersonAvatar(
                avatarPhotoLink: chat.blogAvatar,
                shape: chat.blogAvatarShape,
                blogID: chat.blogID.toString(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    if (chat.read)
                      Row(
                        children: <Widget>[
                          Text(
                            chat.blogUsername,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            chat.blogUsername,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: <Widget>[Text(chat.lastMessage)],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          //height: 10,
          thickness: 1,
          color: Colors.grey.withOpacity(0.3),
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          //leading: ProfilesList(),
          title: const ProfilesList(),
          actions: <Widget>[
            PopupMenuButton<dynamic>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (final BuildContext context) =>
                  <PopupMenuItem<dynamic>>[
                const PopupMenuItem<dynamic>(
                  value: 1,
                  child: Text("Refresh"),
                ),
                const PopupMenuItem<dynamic>(
                  value: 2,
                  child: Text("Settings"),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Row(children: const <Widget>[Text("From Waleed")]),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 15),
                itemCount: chats.length,
                itemBuilder: (final BuildContext context, final int index) {
                  final Chat chat = chats[index];

                  return _buildChat(chat);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
