import "package:flutter_test/flutter_test.dart";
import "package:tumbler/Methods/email_password_validators.dart";

void main() {
  test("Empty Email", () {
    final String? result = emailValidator("");
    expect(result, "Please Enter a Valid Email");
  });

  test("Not Correct Email", () {
    String? result = emailValidator("hello");
    expect(result, "Please Enter a Valid Email");

    result = emailValidator("sds@");
    expect(result, "Please Enter a Valid Email");

    result = emailValidator("sds@sdsd");
    expect(result, "Please Enter a Valid Email");

    result = emailValidator("sds@asdasd.");
    expect(result, "Please Enter a Valid Email");
  });

  test("Correct Email", () {
    final String? result = emailValidator("ziyad@gmail.com");
    expect(result, null);
  });

  test("Empty Password", () {
    final String? result = passValidator("");
    expect(result, "Please Enter 8 Char Long Password");
  });

  test("Less Than 8 char Password", () {
    final String? result = passValidator("12345");
    expect(result, "Please Enter 8 Char Long Password");
  });

  test("More than 8 char Password but doesn't contain UPPER char", () {
    String? result = passValidator("123456789");
    expect(result, "Please Enter at least one UPPER Char");

    result = passValidator("ziyad123456789");
    expect(result, "Please Enter at least one UPPER Char");
  });

  test("More than 8 char Password but doesn't contain lower char", () {
    final String? result = passValidator("ZIYAD123456789");
    expect(result, "Please Enter at least one lower Char");
  });

  test("Password contain Spaces", () {
    final String? result = passValidator("ZIYcAD123 456789");
    expect(result, "Passwords can't contain Spaces");
  });

  test("Correct Password", () {
    final String? result = passValidator("Ziyad123456789");
    expect(result, null);
  });
}
