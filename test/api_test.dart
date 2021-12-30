import "dart:convert";
import "dart:io";
import "package:flutter_test/flutter_test.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart";
import "package:http/testing.dart";
import "package:tumbler/Methods/api.dart";
import "../lib/Models/user.dart";

void main() {
  test('Add post', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    HttpOverrides.global = _MyHttpOverrides();
    final api = Api();
    api.client = MockClient((request) async {
      return Response(
          json.encode({
            "meta": {"status": "200", "msg": "OK"},
            "response": {
              "post_id": 5,
              "blog_id": 5,
              "blog_username": "",
              "blog_avatar": "",
              "blog_avatar_shape": "",
              "blog_title": "",
              "pinned": false,
              "post_time": "2012-02-30",
              "post_type": "general",
              "post_body":
                  "<div> <h1>What's Artificial intellegence? </h1> <img src='https://modo3.com/thumbs/fit630x300/84738/1453981470/%D8%A8%D8%AD%D8%AB_%D8%B9%D9%86_Google.jpg' alt=''> <p>It's the weapon that'd end the humanity!!</p> <video width='320' height='240' controls> <source src='movie.mp4' type='video/mp4'> <source src='movie.ogg' type='video/ogg'> Your browser does not support the video tag. </video> <p>#AI #humanity #freedom</p> </div>"
            }
          }),
          200);
    });
    final res = await api.addPost(
        "<p>out post</p>", "published", "general", "2021-12-29", "2");
    expect(res["meta"]["status"], "200");
  });
}

class _MyHttpOverrides extends HttpOverrides {}
