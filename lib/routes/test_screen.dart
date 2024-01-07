// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';
import "package:file_picker/file_picker.dart";
import 'dart:io';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String filePath = "";

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );

    print(res ?? 'failed to load model');
  }

  Future<void> testModel() async {
    try {
      print("Testing model");
      var output = await Tflite.runModelOnImage(
        path: filePath,
      );

      print("Output : $output");
    } catch (e) {
      print("Encountered an error testing the model");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test and debugging")),
      body: const Column(children: [
        Text("Test Screen"),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            File file = File(result.files.single.path!);
            setState(() {
              filePath = file.path;
            });

            testModel();
          } else {
            // User canceled the picker
          }
        },
        child: const Icon(Icons.file_open),
      ),
    );
  }
}
