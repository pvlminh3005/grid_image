import 'dart:io';

import 'package:flutter/material.dart';

class PanZoomImage extends StatefulWidget {
  final File? image;
  final int? width;
  final int? height;

  const PanZoomImage({
    this.image,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  State<PanZoomImage> createState() => _PanZoomImageState();
}

class _PanZoomImageState extends State<PanZoomImage> {
  late TransformationController controller;
  double offsetX = 0.0;
  double offsetY = 0.0;
  double scaleX = 0.0;
  double scaleY = 0.0;

  final double size = 300.0;

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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInfoImage(),
        ],
      ),
    );
  }

  Matrix4 _getZoomInfo(int width, int height, double size, double zoom) {
    double aspect = width / height;
    double ww = width * zoom;
    double hh = ww / aspect;

    double offsetX = (size / 2) - (ww / 2);
    double offsetY = ((size / aspect) / 2) - (hh / 2);

    Matrix4 matrix = Matrix4.identity();

    matrix.setEntry(0, 0, zoom);
    matrix.setEntry(1, 1, zoom);
    matrix.setEntry(0, 3, offsetX);
    matrix.setEntry(1, 3, offsetY);

    return matrix;
  }

  Widget _buildInfoImage() {
    return SizedBox(
      width: size,
      height: size,
      child: InteractiveViewer(
        transformationController: controller,
        minScale: 1.5,
        maxScale: 4.0,
        onInteractionUpdate: (ScaleUpdateDetails details) {},
        child: Image.file(
          widget.image!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width * 0.49))
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
