import 'dart:io';

import 'package:flutter/material.dart';

class ImageGridProvider with ChangeNotifier {
  List<File> _listImages = [];
  List<File> get listImages => _listImages;

  Future<void> addNewImage(File? image) async {
    _listImages.add(image!);
    notifyListeners();
  }

  Future<void> changeImage(int index, File? image) async {
    _listImages[index] = image!;
    notifyListeners();
  }
}
