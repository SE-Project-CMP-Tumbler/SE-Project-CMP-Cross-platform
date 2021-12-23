import "package:flutter/material.dart";



///Widget to show the avatar added on it the icon type passed to it
class AvatarWithIcon extends StatelessWidget {
  ///Takes avatarUrl and iconType
  AvatarWithIcon({
    required final this.avatarUrl,
    required final this.iconType,
    final Key? key,
  }) : super(key: key);

  ///avatar photo url
  final String avatarUrl;

  ///icon type to show it as a badge on the photo
  final String iconType;

  /// To map a notification type to its corresponding icon photo
  final Map<String, String> images = <String, String>{
    "reply": "icons8-speech-15.png",
    "like": "icons8-love-circled-15.png",
    "reblog": "icons8-sync-15.png",
    "follow": "icons8-add-15.png",
    "mention": "icons8-email-sign-15.png",
    "ask": "icons8-help-15.png"
  };

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        overflow: Overflow.visible,
        children: [
          Image.network(
            avatarUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: -5,
            right: -5,
            child: Image.asset("./assets/images/${images[iconType]}"),
          )
        ],
      ),
    );
  }
}