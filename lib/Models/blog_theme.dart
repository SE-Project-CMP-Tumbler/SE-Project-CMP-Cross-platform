// ignore_for_file: public_member_api_docs
class BlogTheme {
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

  String themeID;
  String titleText;
  String titleColor;
  String titleFont;
  String titleWeight;
  String description;
  String backgroundColor;
  String accentColor;
  String bodyFont;
  String headerImage;
  String avatarURL;
  String avatarShape;

  static BlogTheme fromJSON(final Map<String, dynamic> json) {
    return BlogTheme(
      themeID: json["response"]["theme-id"].toString(),
      titleText: json["response"]["title"][0]["text"],
      titleColor: json["response"]["title"][0]["color"].toString().substring(1),
      titleFont: json["response"]["title"][0]["font"],
      titleWeight: json["response"]["title"][0]["font_weight"],
      description: json["response"]["description"][0]["text"],
      backgroundColor:
          json["response"]["background_color"].toString().substring(1),
      accentColor: json["response"]["accent_color"].toString().substring(1),
      bodyFont: json["response"]["body_font"],
      headerImage: json["response"]["header_image"][0]["url"],
      avatarURL: json["response"]["avatar"][0]["url"],
      avatarShape: json["response"]["avatar"][0]["shape"],
    );
  }
}
