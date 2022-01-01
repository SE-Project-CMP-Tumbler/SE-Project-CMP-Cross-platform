/// Model of the User
class User {
  /// Current Blog the User use
  static int currentProfile = 0;

  /// Age of the User
  static int age = 0;

  /// Email of the User
  static String email = "";

  /// ID of the User
  static String userID = "";

  /// Access Token of the User
  static String accessToken = "";

  /// Google Access Token (if sign in with Google)
  static String googleAccessToken = "";

  /// List of the Blog IDs of the User
  static List<String> blogsIDs = <String>[];

  /// List of the Blog Names of the User
  static List<String> blogsNames = <String>[];

  /// List of the Blog Avatar URLs of the User
  static List<String> avatars = <String>[];

  /// List of the Blog Avatar Shape of the User
  static List<String> avatarShapes = <String>[];

  /// List of the Blog Header URLs of the User
  static List<String> headerImages = <String>[];

  /// List of the Blog Titles of the User
  static List<String> titles = <String>[];

  /// List of the Blog Description of the User
  static List<String> descriptions = <String>[];

  /// List of Booleans to indicate which Blog allow Ask
  static List<bool> allowAsk = <bool>[];

  /// List of Booleans to indicate which Blog allow Submission
  static List<bool> allowSubmission = <bool>[];

  /// List of Booleans to indicate which Blog is Primary
  static List<bool> isPrimary = <bool>[];
}
