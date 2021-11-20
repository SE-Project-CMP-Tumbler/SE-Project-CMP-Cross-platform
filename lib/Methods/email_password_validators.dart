/// Checks [email] validation.
///
/// Returns `null` if this [email] follow valid email regex.
String? emailValidator(final String? email) {
  return email!.contains(
    RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ),
  )
      ? null
      : "Please Enter a Valid Email";
}

/// Checks [password]
///
/// Returns `null` if this [password] is 8 char long,
/// contain at least 1 Upper char, contain at least 1 lower char
/// and doesn't contain spaces.
String? passValidator(final String? password) {
  return password!.length < 8
      ? "Please Enter 8 Char Long Password"
      : password.contains(RegExp("(?=.*[A-Z])")) == false
          ? "Please Enter at least one UPPER Char"
          : password.contains(RegExp("(?=.*[a-z])")) == false
              ? "Please Enter at least one lower Char"
              : password.contains(" ")
                  ? "Passwords can't contain Spaces"
                  : null;
}
