import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionResponse {
  final String confidence;
  final String prediction;

  PredictionResponse({
    required this.confidence,
    required this.prediction,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      confidence: json['confidence'],
      prediction: json['predicted_class'],
    );
  }
}

class StoredPrediction {
  final String prediction;
  final String confidence;
  final String userId;
  final Timestamp time;

  StoredPrediction({
    required this.prediction,
    required this.confidence,
    required this.userId,
    required this.time,
  });

  factory StoredPrediction.fromJson(Map<String, dynamic> json) {
    return StoredPrediction(
      prediction: json['prediction'],
      confidence: json['confidence'],
      userId: json['userId'],
      time: json['time'],
    );
  }
}
