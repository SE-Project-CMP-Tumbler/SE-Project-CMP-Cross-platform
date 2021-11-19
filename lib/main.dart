import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Providers/followed_tags_sign_up.dart';
import './Screens/Sign_Up_Screens/Choose_Tag/tag_page.dart';
import './Screens/Add_Post/html_editor.dart';

void main() {
  runApp(AddPostPage());
}



/*class MyApp extends StatelessWidget {
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
}*/
