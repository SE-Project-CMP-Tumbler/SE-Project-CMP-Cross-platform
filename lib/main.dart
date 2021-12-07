import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tumbler/Providers/followed_tags_sign_up.dart";
import "package:tumbler/Providers/posts.dart";
import "package:tumbler/Screens/Intro_Screens/on_start_screen.dart";
import "package:tumbler/Screens/Add_Post/add_new_post.dart";

void main() => runApp(MyApp());

/// The Start of the Application
class MyApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<FollowedTags>(
          create: (final _) => FollowedTags(),
        ),
        ChangeNotifierProvider<Posts>(
          create: (final _) => Posts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AddPost(),
      ),
    );
  }
}
