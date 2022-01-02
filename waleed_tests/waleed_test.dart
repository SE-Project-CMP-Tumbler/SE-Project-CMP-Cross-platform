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
  test("successful like test", () async {
    final Api newApi = Api();
    newApi.client = MockClient((final dynamic request) async {
      return Response(
        json.encode(<String, dynamic>{
          "meta": 200,
          "response": "abbas",
        }),
        200,
      );
    });
    final Map<String, dynamic> res = await newApi.likePost(15);
    expect(res["meta"], 200);
  });
}

class _MyHttpOverrides extends HttpOverrides {}
