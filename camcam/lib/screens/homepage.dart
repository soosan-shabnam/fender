import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:camcam/screens/view.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/image.jpg"), fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Center(
          child: SizedBox(
            height: 400,
            width: 320,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 80.0,
              ),
              label: const FittedBox(
                child: Text(
                  'Camera',
                  style: TextStyle(fontSize: 65),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => View(camera: camera,)));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
