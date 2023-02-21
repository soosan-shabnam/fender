import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:camcam/util/predictions.dart';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';

class DisplayResultScreen extends StatefulWidget {
  const DisplayResultScreen({Key? key, required this.imgPath})
      : super(key: key);

  final String imgPath;

  @override
  State<DisplayResultScreen> createState() => _DisplayResultScreenState();
}

class _DisplayResultScreenState extends State<DisplayResultScreen> {
  FlutterTts ftts = FlutterTts();

  Future<String> imageTobase64({required imgPath}) async {
    File imageFile = File(imgPath);
    Uint8List bytes = await imageFile.readAsBytes();
    String base64String = base64.encode(bytes);

    return base64String;
  }

  Future<Predictions> fetchPredictions() async {
    String imgStream = await imageTobase64(imgPath: widget.imgPath);

    final response = await http.post(
      Uri.parse('https://9d33-45-64-223-76.in.ngrok.io/api/detect'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"imgStream": imgStream}),
    );

    if (response.statusCode == 200) {
      return Predictions.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  String fetchPredictionClasses({required futurePredictions}) {
    List<String> prediction_classes_names = <String>[];
    if (futurePredictions.pred_classes.isNotEmpty) {
      for (int i = 0; i < futurePredictions.pred_classes.length; i++) {
        prediction_classes_names.add(futurePredictions.classes[i]);
      }
      return prediction_classes_names.join(' ');
    } else {
      return "No objects detected in the scene";
    }
  }

  late Future<Predictions> futurePredictions;

  @override
  void initState() {
    super.initState();
    futurePredictions = fetchPredictions();
  }

  @override
  Widget build(BuildContext context) {
    speak(String text) async {
      await ftts.setLanguage("en-US");
      await ftts.setPitch(1.5);
      await ftts.speak(text);
    }

    return Scaffold(
      body: Center(
        child: FutureBuilder<Predictions>(
          future: futurePredictions,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String text = fetchPredictionClasses(futurePredictions: snapshot.data);
              speak(text);
              return Text(text);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
