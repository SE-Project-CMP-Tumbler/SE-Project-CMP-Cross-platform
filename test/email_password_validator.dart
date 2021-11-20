import 'package:flutter_test/flutter_test.dart';
import 'package:tumbler/Methods/email_password_validators.dart';

void main()
{
  test("Empty Email", (){
    var result = emailValidator("");
    expect(result, "Please Enter a Valid Email");
  });

  test("Not Correct Email", (){
    var result = emailValidator("hello");
    expect(result, "Please Enter a Valid Email");

    result = emailValidator("sds@");
    expect(result, "Please Enter a Valid Email");

    result = emailValidator("sds@sdsd");
    expect(result, "Please Enter a Valid Email");

    result = emailValidator("sds@asdasd.");
    expect(result, "Please Enter a Valid Email");
  });

  test("Correct Email", (){
    var result = emailValidator("ziyad@gmail.com");
    expect(result, null);
  });


  test("Empty Password", (){
    var result = passValidator("");
    expect(result, "Please Enter 8 Char Long Password");
  });

  test("Less Than 8 char Password", (){
    var result = passValidator("12345");
    expect(result, "Please Enter 8 Char Long Password");
  });

  test("More than 8 char Password but doesn't contain UPPER char", (){
    var result = passValidator("123456789");
    expect(result, "Please Enter at least one UPPER Char");

    result = passValidator("ziyad123456789");
    expect(result, "Please Enter at least one UPPER Char");
  });

  test("More than 8 char Password but doesn't contain lower char", (){
    var result = passValidator("ZIYAD123456789");
    expect(result, "Please Enter at least one lower Char");
  });

  test("Password contain Spaces", ()
  {
    var result = passValidator("ZIYcAD123 456789");
    expect(result, "Passwords can't contain Spaces");
  });

  test("Correct Password", ()
  {
    var result = passValidator("Ziyad123456789");
    expect(result, null);
  });
}
