import 'package:flutter/material.dart';
import "package:tumbler/Models/message.dart";


List<Message> messages = [
  Message("Salama", "Waleed",
      "Hello, Welcome my friend Waleed , Hello Hello Hello "),
  Message("Waleed", "Salama", "Hello"),
  Message("Waleed", "Salama", "How are you?"),
  Message("Salama", "Waleed", "Iam fine"),
  Message("Salama", "Waleed", "What about you?"),
  Message("Waleed", "Salama", "Iam fine thanks"),
  Message("Salama", "Waleed", "I just want to ask you a question"),
  Message("Waleed", "Salama", "??"),
  Message("Salama", "Waleed", "why should we learn flutter?"),
  Message("Waleed", "Salama", "Ooh"),
  Message("Waleed", "Salama", "good Question.."),
  Message("Waleed", "Salama",
      "That is because flutter has many advantges as laylo laylo laylo la la la"),
  Message("Waleed", "Salama", "That is because flutter has many advantges as "),
  Message("Salama", "Waleed", "Great answer, Than you"),
  Message("Waleed", "Salama", "<3"),
];

///Chat screen
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool hasContent = false;
  _buildMessage(Message message, bool Change) {
    return Container(
      // margin: EdgeInsets.only(right: 30),
      //width: MediaQuery.of(context).size.width * 0.65,
      child: Change
          ? Container(
              //margin: EdgeInsets.only(top: 1.0, bottom: 1.0),
              //padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 2.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                    width: 41,
                    height: 42,
                    child: Image(
                      image: AssetImage("assets/images/profile_pic.png"),
                    ),
                  ),
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
                        // Flexible(
                        // child:
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.65,
                          ),
                          //width:
                          //MediaQuery.of(context).size.width * 0.65, ////
                          //margin: EdgeInsets.only(right: 25),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 1.0),
                          child: Text(message.text),
                        ),
                        //),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Row(
              //mainAxisSize: MediaQuery.of(context).size.width * 0.65,
              children: [
                Container(
                    //width: MediaQuery.of(context).size.width * 0.65, ////
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
                    //margin: EdgeInsets.only(right: 25.0),

                    child: Text(message.text)),
              ],
            ),
    );
  }

  final _messageController = new TextEditingController();
  submitMessage() {
    setState(() =>
        messages.add(Message("Salama", "Waleed", _messageController.text)));
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
                onPressed: hasContent ? submitMessage : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  final _controller = ScrollController();
  @override
  Widget build(final BuildContext context) {
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
          title: Text("Salama" + " + " + "Waleed"),
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
                  //reverse: true,
                  controller: _controller,
                  padding: EdgeInsets.only(top: 15.0),
                  itemCount: messages.length,
                  // shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    print(index);
                    // _controller.jumpTo(_controller.position.maxScrollExtent);

                    final Message message = messages[index];
                    bool change = true;
                    if (index != 0 &&
                        messages[index - 1].sender == messages[index].sender) {
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