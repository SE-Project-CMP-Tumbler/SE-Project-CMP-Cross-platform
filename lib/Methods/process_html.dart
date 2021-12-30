import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/show_toast.dart";

/// Get URL for all the Encoded Images, Videos, Audios
/// in [htmlBeforeProcessing] from [Api]
Future<String> extractMediaFiles(final String htmlBeforeProcessing) async {
  // Getting all images
  String html = htmlBeforeProcessing;
  int index1 = 0;
  int index2 = 0;
  int x = 0;
  Map<String, dynamic> url;

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<img src=", index1);
    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded image
      index1 = html.indexOf('"', index2); // the end of the encoded image

      //since the html size changes in each iteration
      final String image = html.substring(x + 10, index1);
      url = await Api().uploadImage(image);

      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(
          x + 10,
          index1,
          "${url["response"]["url"]}",
        );
        index1 = html.indexOf('"', index2); //repeating this line is important
      } else {
        await showToast("Failed To Upload Images");
      }
    }
  }

  // Getting all Videos
  index1 = 0;
  index2 = 0;
  x = 0;
  url = <String, dynamic>{};

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<video", index1);

    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded video
      index1 = html.indexOf('"', index2); // the end of the encoded video

      //since the html size changes in each iteration
      final String video = html.substring(x + 24, index1);
      url = await Api().uploadVideo(video);
      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(
          x + 24,
          index1,
          "${url["response"]["url"]}",
        );
        index1 = html.indexOf('"', index2); //repeating this line is important
      } else {
        await showToast("Failed To Upload videos");
      }
    }
  }

  // Getting all Audio
  index1 = 0;
  index2 = 0;
  x = 0;
  url = <String, dynamic>{};

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<audio", index1);
    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded audio
      index1 = html.indexOf('"', index2); // the end of the encoded audio

      //since the html size changes in each iteration
      final String audio = html.substring(x + 24, index1);
      url = await Api().uploadAudio(audio);

      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(
          x + 24,
          index1,
          "${url["response"]["url"]}",
        );
        index1 = html.indexOf('"', index2); //repeating this line is important
      } else {
        await showToast("Failed To Upload Audios");
      }
    }
  }
  return html;
}
