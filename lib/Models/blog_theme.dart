/// Model for the Blog Theme
class BlogTheme {
  /// Constructor
  BlogTheme({
    required this.themeID,
    required this.titleText,
    required this.titleColor,
    required this.titleFont,
    required this.titleWeight,
    required this.description,
    required this.backgroundColor,
    required this.accentColor,
    required this.bodyFont,
    required this.headerImage,
    required this.avatarURL,
    required this.avatarShape,
  });

  /// Theme ID
  String themeID;

  /// Title of the Blog
  String titleText;

  /// Color of the Text of the Title
  String titleColor;

  /// Font of the Text of the Title
  String titleFont;

  /// Weight of the Text of the Title
  String titleWeight;

  /// Description of the Blog
  String description;

  /// Background Color of the Blog
  String backgroundColor;

  /// Accent Color of the Blog
  String accentColor;

  /// Font of the Text of the Body
  String bodyFont;

  /// URL of the Header Image of the Blog
  String headerImage;

  /// URL of the Avatar of the Blog
  String avatarURL;

  /// Shape of the Avater
  String avatarShape;

  /// Constructor form the Json
  static BlogTheme fromJSON(final Map<String, dynamic> json) {
    return BlogTheme(
      themeID: json["response"]["theme-id"].toString(),
      titleText: json["response"]["title"] ?? " ",
      titleColor: json["response"]["color_title"].toString().substring(1),
      titleFont: json["response"]["font_title"] ?? " ",
      titleWeight: json["response"]["font_weight_title"] ?? " ",
      description: json["response"]["description"] ?? " ",
      backgroundColor:
          json["response"]["background_color"].toString().substring(1),
      accentColor: json["response"]["accent_color"].toString().substring(1),
      bodyFont: json["response"]["body_font"] ?? " ",
      headerImage: json["response"]["header_image"] ?? " ",
      avatarURL: json["response"]["avatar"] ?? " ",
      avatarShape: json["response"]["avatar_shape"] ?? " ",
    );
  }
}
