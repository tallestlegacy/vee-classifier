// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:classifier/constants.dart';
import 'package:classifier/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/network.dart';
import "camera_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imagePath = "";
  bool isLoadingPrediction = false;
  PredictionResponse? prediction;
  bool isLoadingSave = false;
  bool isSaved = false;

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

  Future<void> savePrediction() async {
    try {
      setState(() {
        isLoadingSave = true;
      });

      // var imageUrl = await uploadImageToCloudStorage();
      //
      // if (imageUrl != null) {
      //   print("Image URL: $imageUrl");
      //   // show toast
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text("Image uploaded successfully"),
      //   ));
      // }

      await FirebaseFirestore.instance.collection(predictionsCollection).add({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "email": FirebaseAuth.instance.currentUser!.email,
        "prediction": prediction?.prediction,
        "confidence": prediction?.confidence,
        // "imageUrl": imageUrl,
        "time": DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Prediction saved successfully"),
      ));

      setState(() {
        isSaved = true;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoadingSave = false;
      });
    }
  }

  Future<String?> uploadImageToCloudStorage() async {
    final storage = FirebaseStorage.instance;
    try {
      var res = await storage
          .ref()
          .child("predictions")
          .child(imagePath)
          .putFile(File(imagePath));

      return res.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<void> getImagePrediction() async {
    try {
      setState(() {
        isLoadingPrediction = true;
      });
      var res = await getPrediction(File(imagePath));
      print(res);

      if (res != null) {
        setState(() {
          prediction = PredictionResponse.fromJson(res);
          isSaved = false;
        });
      }

      print(res);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoadingPrediction = false;
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
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              title: Text("Classifier"),
            )
          ];
        },
        body: ListView(
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

                      isLoadingPrediction
                          ? const LinearProgressIndicator()
                          : const SizedBox.shrink(),

                      // File preview
                      ListTile(
                        title: Text("File cached in $imagePath"),
                        subtitle: const Text(
                            "Click the 'test' button on the right to initiate image prediction."),
                        // NOTE Press this button to initiate image prediction
                        trailing: IconButton(
                          isSelected: isLoadingPrediction,
                          icon: const Icon(Icons.science_outlined),
                          onPressed: getImagePrediction,
                        ),
                      ),

                      isLoadingSave
                          ? const LinearProgressIndicator()
                          : prediction != null
                              ? const Divider(thickness: 1.2)
                              : const SizedBox.shrink(),

                      // NOTE Display the prediction
                      prediction != null
                          ? ListTile(
                              title:
                                  Text("Prediction: ${prediction!.prediction}"),
                              subtitle:
                                  Text("Confidence: ${prediction!.confidence}"),
                              trailing: !isSaved
                                  ? IconButton(
                                      onPressed: savePrediction,
                                      icon: const Icon(Icons.backup_outlined))
                                  : const Icon(Icons.cloud_done_outlined),
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("To start, take a new picture")),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: !isLoadingPrediction
          ? FloatingActionButton.extended(
              onPressed: () {
                getImagePathAfterNavigation(context);
              },
              label: imagePath == ""
                  ? const Text("Take a picture of the suspected area")
                  : const Text("Re-take the picture"),
              icon: const Icon(Icons.camera_rounded),
            )
          : null,
    );
  }
}
