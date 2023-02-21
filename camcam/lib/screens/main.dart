import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camcam/screens/homepage.dart';

List<CameraDescription> cameras = [] ;

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(camera: widget.camera),
    );
  }
}


