import "package:flutter/material.dart";

///
class EmptyBoxImage extends StatelessWidget {
  ///
  const EmptyBoxImage({required final this.msg, final Key? key})
      : super(key: key);

  /// msg to show
  final String msg;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
