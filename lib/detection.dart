import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Detection extends StatefulWidget {
  const Detection(
      {super.key, required this.imagePath, required this.predictions});

  final String imagePath;
  final List<dynamic> predictions;

  @override
  State<Detection> createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detección")),
      body: FutureBuilder(
          future: body(context),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            Widget? child;
            if (snapshot.hasData) {
              child = snapshot.data;
            }
            return Center(child: child ?? const Text("Loading..."));
          }),
    );
  }

  Future<ui.Image> _loadImage(String path) async {
    File file = File(path);
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }

  Future<Widget> body(context) async {
    ui.Image img = await _loadImage(widget.imagePath);
    return Center(
      child: InteractiveViewer(
        maxScale: 2,
        minScale: 0.1,
        constrained: false,
        scaleFactor: 0.1,
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size(img.width.toDouble(), img.height.toDouble()),
            painter: DetectionPainter(img, widget.predictions),
          ),
        ),
      ),
    );
  }
}

class DetectionPainter extends CustomPainter {
  DetectionPainter(this.image, this.rectangles);

  final ui.Image image;
  final List rectangles;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (final rectangle in rectangles) {
      var limits = rectangle["bbox"];
      var description = rectangle["class"];
      canvas.drawRect(
          Offset(limits[0], limits[1]) & Size(limits[2], limits[3]), paint);
      paintText(
          canvas, Offset(limits[0] + 5, limits[1] + 5), description, size);
      paint.color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    }
  }

  void paintText(canvas, offset, text, size) {
    const textStyle = TextStyle(color: Colors.white, fontSize: 24);
    final textSpan = TextSpan(text: text, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
