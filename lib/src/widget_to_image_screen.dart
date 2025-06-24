import 'package:flutter/material.dart';
import 'package:image_export/src/eco_score_badge.dart';
import 'package:image_export/src/export_image_mixin.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class WidgetToImageScreen extends StatelessWidget with ExportImageMixin {
  final controller = WidgetsToImageController();

  WidgetToImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WidgetsToImageController')),
      body: Column(
        children: [
          WidgetsToImage(controller: controller, child: EcoScoreBadge()),
          ElevatedButton(
            onPressed: () async {
              final image = await controller.capture();
              exportImage(image);
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }
}
