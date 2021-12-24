import "package:flutter/material.dart";

/// Shows informative message about an error occurred
/// while fetching posts in home page.
///
///Takes [context] object and [errorMessage].
Future<void> showErrorDialog(
    final BuildContext context,
    final String errorMessage,
    ) async {
  await showDialog(
    context: context,
    builder: (final BuildContext ctx) {
      return AlertDialog(
        title: const Text("An error occurred"),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Okay"),
          )
        ],
      );
    },
  );
}
