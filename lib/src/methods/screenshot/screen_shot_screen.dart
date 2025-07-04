import 'package:flutter/material.dart';
import 'package:image_export/src/common/eco_score_badge.dart';
import 'package:image_export/src/common/export_certificate_mixin.dart';
import 'package:screenshot/screenshot.dart';

class ScreenShotScreen extends StatelessWidget with ExportCertificateMixin {
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
                final bytes = await controller.captureFromWidget(
                  EcoScoreBadge(),
                );
                export(bytes: bytes, format: 'png');
              },
              child: Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
