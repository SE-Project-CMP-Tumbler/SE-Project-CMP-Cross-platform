import "package:flutter/material.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/chat.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Screens/Chat/inside_chat.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

//////////////////////////////////////////////////////////////////////////////////

List<Chat> chats = <Chat>[];

Future<void> loadChats() async {
  // clear all loaded post.
  final Map<String, dynamic> response = await Api().getChats();
  //checking the status code of the received response.
  if (response["meta"]["status"] == "200") {
    chats.clear();
    final List<dynamic> chatsList = response["response"]["chat_messages"];
    print(chatsList);
    for (int i = 0; i < chatsList.length; i++) {
      final String chk = chatsList[i]["blog_id"].toString();
      if (chk == User.blogsIDs[User.currentProfile]) {
        chats.add(
          Chat(
            chatsList[i]["text"] ?? "",
            "",
            chatsList[i]["friend_id"] as int,
            chatsList[i]["friend_username"],
            chatsList[i]["friend_avatar"],
            "",
            "",
            chatsList[i]["read"] as bool,
          ),
        );
      } else {
        chats.add(
          Chat(
            chatsList[i]["text"],
            "",
            chatsList[i]["blog_id"] as int,
            chatsList[i]["blog_username"],
            chatsList[i]["blog_avatar"],
            "",
            "",
            chatsList[i]["read"] as bool,
          ),
        );
      }
    }
  } else
    await showToast(response["meta"]["msg"]);
}

////////////////////////////////////////////////////////////////////////////////

class ChatOutView extends StatefulWidget {
  /// Constructor
  const ChatOutView({final Key? key}) : super(key: key);

  @override
  _ChatOutViewState createState() => _ChatOutViewState();
}

class _ChatOutViewState extends State<ChatOutView> {
  @override
  void initState() {
    super.initState();
    loadChats().then((final res) {
      setState(() {});
    });
  }

  Widget _buildChat(final Chat chat) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<ChatScreen>(
                builder: (final BuildContext context) => ChatScreen(
                  withBlogID: chat.blogID.toString(),
                ),
              ),
            );
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
                      children: <Widget>[
                        if (chat.lastMessage != "")
                          Text(chat.lastMessage)
                        else
                          const Text("Photo was sent")
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.grey.withOpacity(0.3),
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 15),
      itemCount: chats.length,
      itemBuilder: (final BuildContext context, final int index) {
        final Chat chat = chats[index];

        return _buildChat(chat);
      },
    );
  }
}
