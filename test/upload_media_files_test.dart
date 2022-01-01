import "dart:io";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_test/flutter_test.dart" show TestWidgetsFlutterBinding;
import "package:test/test.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/follow_blog.dart";
import "package:tumbler/Methods/follow_tags.dart";
import "package:tumbler/Methods/get_all_blogs.dart";
import "package:tumbler/Methods/get_tags.dart";
import "package:tumbler/Methods/random_posts.dart";
import "package:tumbler/Methods/search_utils.dart";
import "package:tumbler/Models/blog.dart";
import "package:tumbler/Models/post_model.dart";
import "package:tumbler/Models/tag.dart";

// ignore: avoid_void_async
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  HttpOverrides.global = _MyHttpOverrides();

  group("Add media files", () {
    // setup
    final Api api = Api();

    test("upload photo", () async {
      // run
      final Map<String, dynamic> result = await api.uploadImage(
          "data:image/png;base64,this-is-the-base64-encode-string");
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("upload video", () async {
      // run
      final Map<String, dynamic> result = await api.uploadImage(
          "data:image/png;base64,this-is-the-base64-encode-string");
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("upload audio", () async {
      // run
      final Map<String, dynamic> result = await api.uploadAudio(
          "data:audio/mp3;base64,this-is-the-base64-encode-string");
      // verify
      expect(result["meta"]["status"], "200");
    });

    test("upload video", () async {
      // run
      final Map<String, dynamic> result = await api.uploadVideo(
          "data:video/mp4;base64,this-is-the-base64-encode-string");
      // verify
      expect(result["meta"]["status"], "200");
    });
  });
}

class _MyHttpOverrides extends HttpOverrides {}
