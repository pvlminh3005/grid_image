import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<File> pickImage({
    bool isGallery = true,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final imageFile = await ImagePicker().pickImage(source: source);

    return File(imageFile!.path);
  }

  static final List<CropAspectRatioPreset> _listAspects = [
    CropAspectRatioPreset.original,
    CropAspectRatioPreset.ratio16x9,
    CropAspectRatioPreset.ratio3x2,
    CropAspectRatioPreset.ratio4x3,
    CropAspectRatioPreset.ratio7x5,
    CropAspectRatioPreset.square,
  ];

  static _androidUISettings() {
    return const AndroidUiSettings(
      lockAspectRatio: false,
    );
  }

  static Future<File?> cropImage(String path) async {
    File? cropFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatioPresets: _listAspects,
      androidUiSettings: _androidUISettings(),
    );
    return cropFile;
  }

  static saveImage() async {}
}
