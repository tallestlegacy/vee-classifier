// A screen that allows users to take a picture using a given camera.
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
  });

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then(
          (value) => {
            if (mounted) {setState(() {})}
          },
        );
  }

  void captureImage() async {
    await cameraController.takePicture().then(
      (XFile file) {
        if (mounted) {
          Navigator.pop(context, file.path);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text("Camera")),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: CameraPreview(cameraController),
            ),
            CameraContolls(
              onCapture: captureImage,
            ),
          ],
        ),
      );
    }

    return const Placeholder();
  }
}

class CameraContolls extends StatelessWidget {
  const CameraContolls({
    super.key,
    required this.onCapture,
  });

  final Function onCapture;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      alignment: Alignment.center,
      child: IconButton.filledTonal(
          onPressed: () {
            onCapture();
          },
          icon: const Icon(Icons.camera_rounded)),
    );
  }
}
