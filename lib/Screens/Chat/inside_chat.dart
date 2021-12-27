import "dart:convert";

import "package:flutter/material.dart";
import "package:pusher_client/pusher_client.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";
import "package:tumbler/Models/message.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Widgets/Post/post_personal_avatar.dart";

List<Message> messages = <Message>[];

///Chat screen
class ChatScreen extends StatefulWidget {
  /// Constructor
  const ChatScreen({required this.withBlogID});

  final String withBlogID;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PusherClient pusher;
  late Channel channel;
  late String friendName;
  late String friendAvatar;
  String chatTitle = " ";

  Future<void> bindEvent(
    final String channelName,
    final String eventName,
  ) async {
    await initPusher();
    await pusher.connect();
    channel = pusher.subscribe(channelName);
    await channel.bind(eventName, (final PusherEvent? last) {
      final String data = last!.data.toString();
      final Map<String, dynamic> encodedRes = jsonDecode(data);
      if (encodedRes["from_blog_id"].toString() !=
          User.blogsIDs[User.currentProfile]) {
        messages.insert(
          0,
          Message(
            encodedRes["from_blog_username"].toString(),
            "",
            encodedRes["text"],
          ),
        );
        setState(() {});
      }
    });
  }

  Future<void> initPusher() async {
    pusher = PusherClient(
      "a59193c9ecc2d49635c0",
      PusherOptions(
        auth: PusherAuth(
          "https://api.dev.tumbler.social/broadcasting/auth",
          headers: <String, String>{
            "Authorization": "Bearer ${User.accessToken}"
          },
        ),
        cluster: "eu",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initialzeMe();
    setState(() {});
  }

  bool hasContent = false;

  Widget _buildMessage(final Message message, final bool change) {
    return Container(
      child: change
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  width: 41,
                  height: 42,
                  child: (message.sender ==
                          User.blogsNames[User.currentProfile])
                      ? PersonAvatar(
                          avatarPhotoLink: User.avatars[User.currentProfile],
                          shape: "",
                          blogID: User.blogsIDs[User.currentProfile],
                        )
                      : PersonAvatar(
                          avatarPhotoLink: friendAvatar,
                          shape: "",
                          blogID: widget.withBlogID,
                        ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 4,
                        ),
                        child: Text(
                          message.sender,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.65,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 1,
                        ),
                        child: Text(message.text),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                  ),
                  margin: const EdgeInsets.only(left: 45, top: 2, bottom: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(message.text),
                ),
              ],
            ),
    );
  }

  final TextEditingController _messageController = TextEditingController();

  Future<void> submitMessage() async {
    messages.insert(
      0,
      Message(
        User.blogsNames[User.currentProfile],
        "",
        _messageController.text,
      ),
    );
    final Map<String, dynamic> res =
        await Api().sendMessages(_messageController.text, "", roomId);
    //checking the status code of the received response.
    if (res["meta"]["status"] == "200") {
      _messageController.clear();
      hasContent = false;
      setState(() {});
    } else
      await showToast(res["meta"]["msg"]);
  }

  Container _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 100,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.camera_alt),
                color: Colors.purple,
                iconSize: 25,
                onPressed: () {},
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(hintText: "Say your thing"),
                  onChanged: (final String newTxt) {
                    if (_messageController.text.isEmpty) {
                      setState(() => hasContent = false);
                    } else {
                      setState(() => hasContent = true);
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                color: Colors.purple,
                iconSize: 25,
                onPressed:
                    _messageController.text.isNotEmpty ? submitMessage : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> loadMessages(final String roomId) async {
    final Map<String, dynamic> response = await Api().getMessages(roomId);
    //checking the status code of the received response.F
    if (response["meta"]["status"] == "200") {
      messages.clear();
      final List<dynamic> messagesList = response["response"]["chat_messages"];
      for (int i = 0; i < messagesList.length; i++) {
        final String sender = messagesList[i]["from_blog_username"];
        const String rec = "";
        messages.insert(
          0,
          Message(
            sender,
            rec,
            messagesList[i]["text"],
          ),
        );
      }
      setState(() {});
    } else
      await showToast(response["meta"]["msg"]);
  }

  String roomId = "";

  Future<void> initialzeMe() async {
    final Map<String, dynamic> response =
        await Api().getRoomId(widget.withBlogID);
    final dynamic droomId = response["response"]["chat_room_id"];
    roomId = droomId.toString();
    final Map<String, dynamic> res =
        await Api().getBlogInformation(widget.withBlogID.toString());
    friendName = res["response"]["username"];
    friendAvatar = res["response"]["avatar"];
    chatTitle = "${User.blogsNames[User.currentProfile]} + $friendName";
    await loadMessages(roomId);
  }

  final ScrollController _controller = ScrollController();

  @override
  Widget build(final BuildContext context) {
    final String channelName = "private-channel-$roomId";
    bindEvent(channelName, "chat-update");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(chatTitle),
          actions: <Widget>[
            PopupMenuButton<dynamic>(
              itemBuilder: (final BuildContext context) =>
                  <PopupMenuItem<dynamic>>[
                const PopupMenuItem<dynamic>(
                  value: 1,
                  child: Text("Delete conversation"),
                ),
                const PopupMenuItem<dynamic>(
                  value: 2,
                  child: Text("Mark as spam"),
                ),
                const PopupMenuItem<dynamic>(
                  value: 3,
                  child: Text("Block"),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                controller: _controller,
                padding: const EdgeInsets.only(top: 15),
                itemCount: messages.length,
                itemBuilder: (final BuildContext context, final int index) {
                  final Message message = messages[index];
                  bool change = true;
                  if (index != messages.length - 1 &&
                      messages[index + 1].sender == messages[index].sender) {
                    change = false;
                  }
                  return _buildMessage(message, change);
                },
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
