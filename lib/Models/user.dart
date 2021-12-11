// ignore_for_file: public_member_api_docs
// ignore_for_file: avoid_classes_with_only_static_members
class User {
  static int currentProfile = 0;
  static int age = 0;
  static String email = "";
  static String userID = "";
  static String accessToken = "";

  static List<String> blogsIDs = <String>[];
  static List<String> blogsNames = <String>[];
  static List<String> avatars = <String>[];
  static List<String> avatarShapes = <String>[];
  static List<String> headerImages = <String>[];
  static List<String> titles = <String>[];
  static List<String> descriptions = <String>[];
  static List<bool> allowAsk = <bool>[];
  static List<bool> allowSubmission = <bool>[];
  static List<bool> isPrimary = <bool>[];
}
