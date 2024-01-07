// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

import "camera_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imagePath = "";

  Future<void> getImagePathAfterNavigation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const CameraScreen()),
    );

    if (!mounted) return;

    setState(() {
      imagePath = result;
    });

    print("Preparing to load model");
    await loadModel().catchError((e) {
      print("failed to load model");
      print(e);
    }).then((value) => {
          if (mounted) {testImage()}
        });
  }

  Future<void> loadModel() async {
    try {
      print("Loading model...");
      String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
      print("Loaded : ${res ?? 'failed'}");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> testImage() async {
    if (imagePath == "") return;

    print("Testing image: $imagePath");

    var file = File(imagePath);

    if (!file.existsSync()) {
      print("File does not exist");
      return;
    }

    try {
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath, // required
      );
      print("Recognitions: $recognitions");
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eczema Classifier")),
      body: Column(
        children: [
          imagePath != ""
              ? Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: Text(imagePath),
                    )
                  ],
                )
              : const Text("No image selected"),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getImagePathAfterNavigation(context);
        },
        label: imagePath == ""
            ? const Text("Take a picture of the suspected area")
            : const Text("Re-take the picture"),
        icon: const Icon(Icons.camera_rounded),
      ),
    );
  }
}
