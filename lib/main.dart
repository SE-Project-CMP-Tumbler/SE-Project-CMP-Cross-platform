import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:provider/provider.dart";
import "package:tumbler/Methods/initializer.dart";
import "package:tumbler/Models/user.dart";
import "package:tumbler/Providers/blogs.dart";
import "package:tumbler/Providers/followed_tags_sign_up.dart";
import "package:tumbler/Providers/tags.dart";
import "package:tumbler/Screens/On_Start_Screens/on_start_screen.dart";
import "package:tumbler/Screens/main_screen.dart";

Future<void> main() async {
  await dotenv.load();
  if (!kIsWeb) {
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
        ChangeNotifierProvider<BlogsData>(
          create: (final _) => BlogsData(),
        ),
        ChangeNotifierProvider<Tags>(
          create: (final _) => Tags(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: User.accessToken.isEmpty ? OnStart() : MainScreen(),
      ),
    );
  }
}
