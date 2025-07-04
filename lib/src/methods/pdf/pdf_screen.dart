import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_export/src/common/export_certificate_mixin.dart';
import 'package:image_export/src/methods/pdf/pdf_generator.dart';

class PdfScreen extends StatelessWidget with ExportCertificateMixin {
  const PdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pdf')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final stopwatch = Stopwatch()..start();
                Timeline.startSync('Pdf');
                final pdfGenerator = PdfGenerator();
                final bytes = await pdfGenerator.generatePdf();
                Timeline.finishSync();
                stopwatch.stop();
                debugPrint('Pdf: ${stopwatch.elapsedMilliseconds} ms');
                export(bytes: bytes, format: 'pdf');
              },
              child: Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
