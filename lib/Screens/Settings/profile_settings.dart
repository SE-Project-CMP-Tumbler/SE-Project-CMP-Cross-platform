import "package:flutter/material.dart";

/// Setting Page
class ProfileSettings extends StatelessWidget {
  /// Constructor
  const ProfileSettings({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("I'm Setting Page"),
      ),
    );
  }
}
