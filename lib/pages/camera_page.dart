import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({
    required this.cameras,
    Key? key,
  }) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController cameraController;
  late Future<void> cameraValue;

  @override
  void initState() {
    super.initState();
    cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    cameraValue = cameraController.initialize();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          !cameraController.value.isInitialized
              ? Container()
              : Expanded(
                  child: CameraPreview(cameraController),
                ),
        ],
      ),
    );
  }
}
