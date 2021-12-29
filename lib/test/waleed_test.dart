import "dart:convert";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart";
import "package:http/testing.dart";
import "package:tumbler/Methods/api.dart";

void main() {
  group("like test", () {
    test("successful like test", () {
      Api.client = MockClient((final request) async {
        return Response(json.encode("abbas"), 200);
      });
    });

    final res = Api().likePost(15);
  });
}
