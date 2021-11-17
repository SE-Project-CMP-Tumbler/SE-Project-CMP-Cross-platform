import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumbler/Providers/followed_tags_sign_up.dart';
import 'package:tumbler/Screens/Sign_Up_Screens/Choose_Tag/tag_page.dart';
import 'package:tumbler/Screens/Sign_Up_Screens/intro_screens/on_start_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /**return ChangeNotifierProvider(
      create: (_) => FollowedTags(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnStart(),
      ),
    );**/
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnStart(),
    );
  }
}
