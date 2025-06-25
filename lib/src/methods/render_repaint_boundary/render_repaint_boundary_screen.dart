import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_export/src/common/eco_score_badge.dart';
import 'package:image_export/src/common/export_image_mixin.dart';
import 'package:image_export/src/methods/render_repaint_boundary/image_generator.dart';

class RenderRepaintBoundaryScreen extends StatelessWidget
    with ExportImageMixin {
  const RenderRepaintBoundaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RenderRepaintBoundary')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final stopwatch = Stopwatch()..start();
                Timeline.startSync('RenderRepaintBoundary');
                final imageGenerator = ImageGenerator();
                await imageGenerator.precacheImages(
                  context,
                  images: EcoScoreBadge.images,
                );
                final bytes = await imageGenerator.generateImageFromWidget(
                  EcoScoreBadge(),
                );
                Timeline.finishSync();
                stopwatch.stop();
                debugPrint(
                  'RenderRepaintBoundary: ${stopwatch.elapsedMilliseconds} ms',
                );
                exportImage(bytes);
              },
              child: Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
