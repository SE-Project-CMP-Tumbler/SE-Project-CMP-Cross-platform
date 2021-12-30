import "dart:convert";

import "package:image_picker/image_picker.dart";

/// To make the user image from the gallery or to open the camera to get a photo
Future<String?> chooseImage(final ImageSource src) async {
  final XFile? image = await ImagePicker().pickImage(source: src);
  if (image != null)
    return base64.encode(await image.readAsBytes());
  else
    return null;
}
