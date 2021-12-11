import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:provider/provider.dart";
import "package:tumbler/Methods/initializer.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Providers/followed_tags_sign_up.dart";
import "package:tumbler/Providers/posts.dart";
import "package:tumbler/Screens/Intro_Screens/on_start_screen.dart";
import "package:tumbler/Screens/main_screen.dart";

Future<void> main() async {
  await dotenv.load();
  if(!kIsWeb) {
    await initializeUserData();
    await initializeUserBlogs();
  }
  runApp(MyApp());
}

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
        //home: AddPost(),
        home: User.accessToken.isEmpty ? OnStart() : MainScreen(),
      ),
    );
  }
}
