// ignore_for_file: avoid_print

import 'dart:io';

import 'package:http/http.dart' as http;

const apiUrl = "https://ic-z7zmwc5wdq-uc.a.run.app";

Future<dynamic> getPrediction(File image) async {
  var url = "$apiUrl/predict";

  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(http.MultipartFile.fromBytes(
    'file',
    await image.readAsBytes(),
    filename: image.path.split("/").last,
  ));

  try {
    print("Sending request");
    var response = await request.send();

    if (response.statusCode == 200) {
      // Image uploaded successfully
      print("Image uploaded successfully");
      return response.stream.bytesToString();
    } else {
      // Handle error
      print("Error uploading image");
      throw Exception('Failed to upload image');
    }
  } catch (error) {
    // Handle error
    print("Error: $error");
    rethrow;
  }
}
