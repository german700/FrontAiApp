import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:toca_pasto/client.dart';
import 'package:toca_pasto/detection.dart';

class TakePhoto extends StatefulWidget {
  final CameraDescription? camera;

  const TakePhoto({super.key, this.camera});

  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera as CameraDescription,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  Future<XFile?> takePicture() async {
    if (_controller.value.isTakingPicture) {
      return null;
    }

    _controller.setFlashMode(FlashMode.off);

    try {
      XFile file = await _controller.takePicture();
      return file;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take picture'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file = await takePicture();
          if (!context.mounted) return;
          if (file == null) {
            Navigator.of(context).pop();
            return;
          }
          processImage(context, file.path);
        },
        child: const Icon(Icons.camera_alt),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void processImage(var context, String imagePath) async {
    DioClient dio = DioClient();
    var predictions = await dio.getPredictions(imagePath);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            Detection(imagePath: imagePath, predictions: predictions),
      ),
    );
  }
}
