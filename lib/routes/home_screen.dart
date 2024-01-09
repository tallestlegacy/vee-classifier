// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/network.dart';
import "camera_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imagePath = "";
  bool isLoading = false;

  Future<void> getImagePathAfterNavigation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const CameraScreen()),
    );

    if (!mounted) return;

    setState(() {
      imagePath = result;
    });
  }

  Future<void> getImagePrediction() async {
    try {
      setState(() {
        isLoading = true;
      });
      var res = await getPrediction(File(imagePath));
      print(res);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                    // NOTE Display the selected image
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.fitWidth,
                      ),
                    ),

                    // File preview
                    ListTile(
                      title: Text("File cached in $imagePath"),
                      subtitle: const Text(
                          "Click the 'upload' button on the right to initiate image prediction."),
                      // NOTE Press this button to initiate image prediction
                      trailing: IconButton(
                        isSelected: isLoading,
                        icon: const Icon(Icons.upload_file_rounded),
                        onPressed: getImagePrediction,
                      ),
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
