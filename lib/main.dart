import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Providers/followed_tags_sign_up.dart';
import 'Screens/Intro_Screens/on_start_screen.dart';


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
