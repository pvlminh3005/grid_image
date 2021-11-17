import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:grid_image/providers/image_provider.dart';
import 'package:grid_image/utils/utils.dart';
import 'package:grid_image/widgets/image_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ImageGridProvider provider = Provider.of<ImageGridProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
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
      body: StaggeredGridView.countBuilder(
        staggeredTileBuilder: (index) => StaggeredTile.count(
          2,
          index.isEven ? 2 : 1,
        ),
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.all(10),
        itemCount: provider.listImages.length,
        itemBuilder: (BuildContext context, int index) {
          return ImageItem(
            index: index,
            file: provider.listImages[index],
          );
        },
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
              File? file = await Utils.pickImage();
              if (file == null) return;
              provider.addNewImage(file);
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
              File? file = await Utils.pickImage(isGallery: false);
              if (file == null) return;
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
