import "package:flutter/material.dart";

/// Widget For Errors
class EmptyBoxImage extends StatelessWidget {
  /// Constructor
  const EmptyBoxImage({required final this.msg, final Key? key})
      : super(key: key);

  /// Error Message to show
  final String msg;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("./assets/images/empty-box.png"),
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
