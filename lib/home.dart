import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toca_pasto/take_photo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CameraDescription _cameraDescription;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Touch Grass")),
      body: Center(
        child: IconButton(
          onPressed: () async {
            if (!context.mounted) return;
            final String? path = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => TakePhoto(camera: _cameraDescription)),
            );
            if (path == null) return;
          },
          icon: const Icon(Icons.camera_alt),
          tooltip: "Tomar foto",
          iconSize: 128,
        ),
      ),
    );
  }
}
