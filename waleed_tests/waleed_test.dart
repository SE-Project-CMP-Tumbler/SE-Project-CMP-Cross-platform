import "dart:convert";
import "dart:io";
import "package:flutter_test/flutter_test.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart";
import "package:http/testing.dart";
import "package:tumbler/Methods/api.dart";

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  HttpOverrides.global = _MyHttpOverrides();
  test("successful like test", () async {
    Api newApi = Api();
    newApi.client = MockClient((final request) async {
      return Response(json.encode({
        "meta":200,
        "response":"abbas",
      }), 200);
    });
    final res = await newApi.likePost(15);
    expect(res["meta"], 200);
  });
}

class _MyHttpOverrides extends HttpOverrides {}
