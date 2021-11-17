import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<File?> pickImage({
    bool isGallery = true,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final imageFile = await ImagePicker().pickImage(source: source);

    if (imageFile == null) {
      return null;
    }

    return cropImage(File(imageFile.path));
  }

  static final List<CropAspectRatioPreset> _listAspects = [
    CropAspectRatioPreset.original,
    CropAspectRatioPreset.ratio16x9,
    CropAspectRatioPreset.ratio3x2,
  ];

  static Future<File?> cropImage(File imageFile) async {
    return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: _listAspects,
      androidUiSettings: _androidUISettings(),
    );
  }

  static _androidUISettings() {
    return const AndroidUiSettings(
      lockAspectRatio: false,
    );
  }
}
