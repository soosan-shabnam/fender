import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:camcam/screens/display_result_screen.dart';
import 'dart:convert';

class View extends StatefulWidget {
  const View({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();

                if (!mounted) return;

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayResultScreen(
                      imgPath: image.path,
                    ),
                  ),
                );
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
