import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_export/src/methods/canvas/canvas_image_generator.dart';
import 'package:image_export/src/common/export_image_mixin.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> with ExportImageMixin {
  Uint8List? _pngBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Canvas')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (_pngBytes != null) Image.memory(_pngBytes!),
            ElevatedButton(
              onPressed: () async {
                final stopwatch = Stopwatch()..start();
                Timeline.startSync('FlutterCanvas');
                _pngBytes = await CanvasImageGenerator().generateImage();
                Timeline.finishSync();
                stopwatch.stop();
                debugPrint(
                  'FlutterCanvas: ${stopwatch.elapsedMilliseconds} ms',
                );
                exportImage(_pngBytes);
                // setState(() {});
              },
              child: Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
