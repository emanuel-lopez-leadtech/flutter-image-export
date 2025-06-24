import 'package:flutter/material.dart';
import 'package:image_export/src/eco_score_badge.dart';
import 'package:image_export/src/export_image_mixin.dart';
import 'package:screenshot/screenshot.dart';

class ScreenShotScreen extends StatelessWidget with ExportImageMixin {
  ScreenShotScreen({super.key});

  final controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ScreenShotController')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //const EcoScoreBadge(),
            ElevatedButton(
              onPressed: () async {
                final image = await controller.captureFromWidget(
                  EcoScoreBadge(),
                );
                exportImage(image);
              },
              child: Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
