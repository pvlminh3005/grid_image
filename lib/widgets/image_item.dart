import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grid_image/providers/image_provider.dart';
import 'package:grid_image/utils/utils.dart';
import 'package:provider/provider.dart';

class ImageItem extends StatelessWidget {
  final int? index;
  final File? file;

  const ImageItem({
    this.index,
    this.file,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageGridProvider provider =
        Provider.of<ImageGridProvider>(context, listen: false);

    return InkWell(
      onTap: () async {
        File? file = await Utils.pickImage();
        if (file == null) return;
        provider.changeImage(index!, file);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          file!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
