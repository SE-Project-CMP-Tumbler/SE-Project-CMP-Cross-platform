import "package:image_picker/image_picker.dart";

/// To make the user image from the gallery or to open the camera to get a photo
Future<XFile?> chooseImageFromGallery(final ImageSource src) async {
  return ImagePicker().pickImage(source: src);
}
