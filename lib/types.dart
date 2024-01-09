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
