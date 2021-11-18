import 'dart:io';
import 'package:extended_image/extended_image.dart';
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
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
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
      body: Column(
        children: [
          Expanded(
            child: imageFile != null
                ? ExtendedImage.file(
                    imageFile!,
                    extendedImageEditorKey: editorKey,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    initEditorConfigHandler: (state) {
                      return EditorConfig(
                        maxScale: 8.0,
                        hitTestSize: 20.0,
                      );
                    },
                  )
                : const Center(
                    child: Text('Nothing Image!'),
                  ),
          ),
          imageFile != null
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomIconButton(
                        icon: Icons.crop,
                        title: 'Crop',
                        onTap: () {},
                      ),
                      CustomIconButton(
                        icon: Icons.rotate_left,
                        title: 'Rotate left',
                        onTap: () {
                          editorKey.currentState!.rotate(right: false);
                        },
                      ),
                      CustomIconButton(
                        icon: Icons.rotate_right,
                        title: 'Rotate right',
                        onTap: () {
                          editorKey.currentState!.rotate(right: true);
                        },
                      ),
                      CustomIconButton(
                        icon: Icons.flip,
                        title: 'Flip',
                        onTap: () {
                          editorKey.currentState!.flip();
                        },
                      ),
                      CustomIconButton(
                        icon: Icons.restore,
                        title: 'Reset',
                        onTap: () {
                          editorKey.currentState!.reset();
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
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

class CustomIconButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Function()? onTap;

  const CustomIconButton({
    this.title = '',
    this.icon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 27,
            color: Colors.white,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
