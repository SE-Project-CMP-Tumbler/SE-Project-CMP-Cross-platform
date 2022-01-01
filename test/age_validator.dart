import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_test/flutter_test.dart";
import "package:tumbler/Methods/age_validation.dart";

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  test("Empty age string", () {
    final String? result = ageValidator("");
    expect(result, "Please Enter a number");
  });

  test("Entering Text", () {
    final String? result = ageValidator("abc");
    expect(result, "Please Enter a Valid Number");
  });

  test("Entering age out of the boundaries", () {
    String? result = ageValidator("12");
    expect(result, "Please Enter age between 13 and 130");
    result = ageValidator("131");
    expect(result, "Please Enter age between 13 and 130");
  });

  test("Entering correct age", () {
    final String? result = ageValidator("50");
    expect(result, null);
  });
}
