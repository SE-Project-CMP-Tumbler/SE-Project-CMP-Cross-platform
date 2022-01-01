import "dart:convert";
import "dart:io";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart";
import "package:http/testing.dart";
import "package:tumbler/Methods/api.dart";

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  HttpOverrides.global = _MyHttpOverrides();
  final Api api = Api();
  group("Post Notes", () {
    test("Get: Post Notes", () async {
      // run
      final Map<String, dynamic> result = await api.getNotes("15");
      // verify
      expect(result["meta"]["status"], "200");
    });
  });

  group("Dashboard posts", () {
    test("Get: Dashboard posts", () async {
      // run
      final Map<String, dynamic> result = await api.fetchHomePosts(1);
      // verify
      expect(result["meta"]["status"], "200");
    });
  });

  group("Follow/Unfollow a Blog", () {
    test("Post: Follow a specific blog by ID", () async {
      // run
      final Map<String, dynamic> result = await api.followBlog(1);
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("Delete: Unfollow a specific blog by ID", () async {
      // run
      final Map<String, dynamic> result = await api.unFollowBlog(1);
      // verify
      expect(result["meta"]["status"], "200");
    });
  });

  group("Like/Unlike posts", () {
    test("Post: Like a post with ID", () async {
      // run
      final Map<String, dynamic> result = await api.likePost(1);
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("Post: Unlike a post with ID", () async {
      // run
      final Map<String, dynamic> result = await api.unlikePost(1);
      // verify
      expect(result["meta"]["status"], "200");
    });
  });

  group("Reply on posts", () {
    test("Post: Reply posts", () async {
      // run
      final Map<String, dynamic> result = await api.replyOnPost("1", "text");
      // verify
      expect(result["meta"]["status"], "200");
    });
  });

  group("Notifications", () {
    test("GET: get notifications", () async {
      // run
      final Map<String, dynamic> result =
          await api.getActivityNotifications("1");
      // verify
      expect(result["meta"]["status"], "200");
    });
  });
}

class _MyHttpOverrides extends HttpOverrides {}
