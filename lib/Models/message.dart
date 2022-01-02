/// Model of Message
class Message {
  /// Constructor
  Message(this.sender, this.receiver, this.text, this.photo);

  /// Username of the sender
  final String sender;

  /// Username of the Receiver
  final String receiver;

  /// Text of the Message
  final String text;

  /// Url Photo of the message
  final String photo;
}
