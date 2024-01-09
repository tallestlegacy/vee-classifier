import 'package:classifier/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myPredictionsQuery = FirebaseFirestore.instance
        .collection(predictionsCollection)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(title: const Text("My History")),
      body: FirestoreListView<Map<String, dynamic>>(
        query: myPredictionsQuery,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        itemBuilder: (context, snapshot) {
          var data = snapshot.data();
          var prediction = StoredPrediction.fromJson(data);

          return Column(
            children: [
              ListTile(
                title: Text(prediction.time.toDate().toString()),
                subtitle: Text(
                  "${prediction.confidence} chance of ${prediction.prediction}",
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
