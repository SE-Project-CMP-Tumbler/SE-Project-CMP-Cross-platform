/// Validates that [age] is between '13' and '130'
String? ageValidator(final String? age) {
  return age!.isNotEmpty
      ? age.contains(RegExp("^[0-9]+\$"))
          ? (int.parse(age) >= 13 && int.parse(age) <= 130)
              ? null
              : "Please Enter age between 13 and 130"
          : "Please Enter a Valid Number"
      : "Please Enter a number";
}
