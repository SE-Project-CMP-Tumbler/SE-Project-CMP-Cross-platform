import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumbler/Providers/followed_tags_sign_up.dart';
import 'package:tumbler/Screens/Sign_Up_Screens/Choose_Tag/tag_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FollowedTags(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TagSelect(),
      ),
    );
    /**
        return const MaterialApp(
        home: OnStart(),
        );**/
  }
}
