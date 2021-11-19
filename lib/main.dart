import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Screens/intro_screens/on_start_screen.dart';
import '/Providers/followed_tags_sign_up.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FollowedTags(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnStart(),
      ),
    );
  }
}
