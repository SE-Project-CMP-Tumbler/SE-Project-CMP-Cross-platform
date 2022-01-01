import "package:tumbler/Methods/api.dart";

/// Extract the Word after '@' and check if this a valid user from [Api.getUserInfo],
/// if valid, it replace the username with herf mapping to his/her profile.
/// Extract the Word after '#' and replace it with herf mapping to the Tag Page
Future<String> extractMentionsTags(final String htmlBeforeProcessing) async {
  // Getting all mentions
  String html = htmlBeforeProcessing;
  int index1 = 0;
  int x = 0;

  while (x != -1 && index1 <= html.length - 5) {
    x = html.indexOf("@", index1);
    if (x != -1) {
      index1 = html.indexOf(" ", x);
      if (index1 == -1) {
        index1 = html.indexOf("<", x);
      }
      if (index1 == -1) {
        index1 = html.length;
      }

      final String username = html.substring(x + 1, index1);

      final Map<String, dynamic> response = await Api().getUserInfo(username);
      if (response["meta"]["status"] == "200") {
        final String blogID = response["response"]["id"].toString();
        html = html.replaceRange(
          x,
          index1,
          "<a href='mention$blogID'>@$username</a>",
        );
        index1 += 13 + blogID.length;
      }
    }
  }

  index1 = 0;
  x = 0;
  while (x != -1 && index1 <= html.length - 5) {
    x = html.indexOf("#", index1);
    if (x != -1) {
      index1 = html.indexOf(" ", x);
      if (index1 == -1) {
        index1 = html.indexOf("<", x);
      }
      if (index1 == -1) {
        index1 = html.length;
      }

      final String tag = html.substring(x + 1, index1);
      html = html.replaceRange(x, index1, "<a href='tag$tag'>#$tag</a>");
      index1 += 10 + tag.length;
    }
  }

  return html;
}
