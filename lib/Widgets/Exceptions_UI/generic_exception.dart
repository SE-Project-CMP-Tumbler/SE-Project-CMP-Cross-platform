import "package:flutter/material.dart";

/// Widget appear if error happened
class ErrorImage extends StatelessWidget {
  /// Constructor
  const ErrorImage({required final this.msg, final Key? key}) : super(key: key);

  /// Error Message to show
  final String msg;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/frustrated-face.png"),
            Text(
              msg,
              style: const TextStyle(color: Colors.black87, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
