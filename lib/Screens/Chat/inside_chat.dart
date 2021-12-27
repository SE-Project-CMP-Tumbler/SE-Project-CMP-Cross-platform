import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import "package:tumbler/Models/http_requests_exceptions.dart";
import "package:tumbler/Models/message.dart";
import "../../Methods/api.dart";
import "../../Models/user.dart";
//import 'package:tumbler/Widgets/Post/post_personal_avatar.dart';
import '../../Widgets/Post/post_personal_avatar.dart';

List<Message> messages = [];

///Chat screen
class ChatScreen extends StatefulWidget {
  @override
  String with_blog_id;
  ChatScreen(this.with_blog_id);
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PusherClient pusher;
  late Channel channel;
  late String friendName;
  late String friendAvatar;
  String chatTitle = " ";
  void bindEvent(String channelName, String eventName) async {
    await initPusher();
    pusher.connect();
    channel = await pusher.subscribe(channelName);
    await channel.bind(eventName, (final last) {
      final String data = last!.data.toString();
      final encodedRes = jsonDecode(data);
      if (encodedRes["from_blog_id"].toString() !=
          User.blogsIDs[User.currentProfile]) {
        messages.insert(
            0,
            Message(encodedRes["from_blog_username"].toString(), "",
                encodedRes["text"]));
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
          headers: {"Authorization": "Bearer ${User.accessToken}"},
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
  _buildMessage(Message message, bool Change) {
    return Container(
      child: Change
          ? Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 5.0, bottom: 2.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      width: 41,
                      height: 42,
                      child: (message.sender ==
                              User.blogsNames[User.currentProfile])
                          ? PersonAvatar(
                              avatarPhotoLink:
                                  User.avatars[User.currentProfile],
                              shape: "",
                              blogID: User.blogsIDs[User.currentProfile])
                          : PersonAvatar(
                              avatarPhotoLink: friendAvatar,
                              shape: "",
                              blogID: widget.with_blog_id)),
                  Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 2.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 4.0),
                          child: Text(
                            message.sender,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.65,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 1.0),
                          child: Text(message.text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    margin: EdgeInsets.only(left: 45.0, top: 2, bottom: 2),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        )),
                    child: Text(message.text)),
              ],
            ),
    );
  }

  final _messageController = new TextEditingController();
  submitMessage() async {
    messages.insert(
        0,
        Message(
            User.blogsNames[User.currentProfile], "", _messageController.text));
    final dynamic res =
        await Api().sendMessages(_messageController.text, "", roomId);
    //checking the status code of the received response.
    if (res.statusCode == 401)
      throw HttpException("You are not authorized");
    else if (res.statusCode == 404) {
      throw HttpException("Not Found!");
    }
    _messageController.clear();
    hasContent = false;
    setState(() => {});
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 100.0,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt),
                color: Colors.purple,
                iconSize: 25.0,
                onPressed: () {},
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Say your thing"),
                    onChanged: (newTxt) {
                      print(_messageController.text);
                      if (_messageController.text.isEmpty) {
                        setState(() => hasContent = false);
                      } else {
                        setState(() => hasContent = true);
                      }
                    }),
              ),
              IconButton(
                icon: Icon(Icons.send),
                color: Colors.purple,
                iconSize: 25.0,
                onPressed:
                    _messageController.text.isNotEmpty ? submitMessage : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void loadMessages(String roomId) async {
    final dynamic res = await Api().getMessages(roomId);
    //checking the status code of the received response.F
    if (res.statusCode == 401)
      throw HttpException("You are not authorized");
    else if (res.statusCode == 404) {
      throw HttpException("Not Found!");
    }
    messages.clear();
    final Map<String, dynamic> encodedRes = jsonDecode(res.body);
    final List<dynamic> messagesList = encodedRes["response"]["chat_messages"];
    for (int i = 0; i < messagesList.length; i++) {
      String sender = messagesList[i]["from_blog_username"];
      String rec = "";
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
  }

  String roomId = "";
  dynamic initialzeMe() async {
    final dynamic response = await Api().getRoomId(widget.with_blog_id);
    final Map<String, dynamic> encodedRes = jsonDecode(response.body);
    dynamic droomId = encodedRes["response"]["chat_room_id"];
    roomId = droomId.toString();
    final Map<String, dynamic> res =
        await Api().getBlogInformation(widget.with_blog_id.toString());
    friendName = res["response"]["username"];
    friendAvatar = res["response"]["avatar"];
    chatTitle = User.blogsNames[User.currentProfile] + " + " + friendName;
    loadMessages(roomId);
  }

  final _controller = ScrollController();

  @override
  Widget build(final BuildContext context) {
    String channelName = "private-channel-" + roomId;
    bindEvent(channelName, 'chat-update');
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
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  reverse: true,
                  controller: _controller,
                  padding: EdgeInsets.only(top: 15.0),
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
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
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
