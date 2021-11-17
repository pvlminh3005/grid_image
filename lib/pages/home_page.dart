import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:grid_image/providers/image_provider.dart';
import 'package:grid_image/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TransformationController controller;

  File? imageFile;
  File? defaultImage;

  @override
  void initState() {
    controller = TransformationController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageGridProvider provider = Provider.of<ImageGridProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          imageFile != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      imageFile = null;
                    });
                  },
                  icon: const Icon(
                    CupertinoIcons.clear_circled_solid,
                  ),
                )
              : const SizedBox.shrink(),
          IconButton(
            onPressed: () {
              setState(() {
                imageFile = defaultImage;
              });
            },
            icon: const Icon(CupertinoIcons.refresh_thick),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => _buildBottomSheet(context, provider),
              );
            },
          ),
        ],
      ),
      floatingActionButton: imageFile != null
          ? FloatingActionButton(
              onPressed: () async {
                File? cropImage = await Utils.cropImage(imageFile!.path);
                if (cropImage == null) return;
                setState(() {
                  imageFile = cropImage;
                });
              },
              child: const Icon(Icons.crop),
            )
          : null,
      body: Container(
        alignment: Alignment.center,
        child: imageFile == null
            ? const Text('Nothing')
            : Image.file(
                imageFile!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context, ImageGridProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              File file = await Utils.pickImage();
              // provider.addNewImage(file);
              setState(() {
                imageFile = file;
                defaultImage = file;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF1F1F1),
              ),
              child: Row(
                children: const [
                  Icon(CupertinoIcons.collections),
                  SizedBox(width: 10),
                  Text('Choose from Gallery'),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              File file = await Utils.pickImage(isGallery: false);
              setState(() {
                imageFile = file;
                defaultImage = file;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF3F3F3),
              ),
              child: Row(
                children: const [
                  Icon(CupertinoIcons.camera),
                  SizedBox(width: 10),
                  Text('Choose from Camera'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
