import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  Future<Uint8List> generatePdf() async {
    // Load background image as Uint8List
    final bgBytes = await rootBundle.load('assets/bg.jpg');
    final bgImage = pw.MemoryImage(bgBytes.buffer.asUint8List());

    final pw.Document pdf = pw.Document()
      ..addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(
            width: 990,
            height: 540,
            marginBottom: 0,
            marginTop: 0,
            marginLeft: 0,
            marginRight: 0,
          ),
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Positioned.fill(
                  child: pw.Image(bgImage, fit: pw.BoxFit.cover),
                ),
                pw.Transform.scale(
                  scale: 2.0,
                  child: pw.Center(
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 60,
                          height: 60,
                          child: pw.FlutterLogo(),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Paperless Certificate',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 15,
                          ),
                        ),
                        pw.Text(
                          'Sprout',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 25,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.red400,
                            borderRadius: pw.BorderRadius.circular(16),
                            border: pw.Border.all(
                              color: PdfColors.red800,
                              width: 1,
                            ),
                          ),
                          child: pw.Row(
                            mainAxisSize: pw.MainAxisSize.min,
                            children: [
                              pw.Text(
                                '41',
                                style: pw.TextStyle(
                                  color: PdfColors.red100,
                                  fontSize: 20,
                                ),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Text(
                                'sheets of paper digitalized',
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

    final binaryFile = await pdf.save();
    return binaryFile;
  }
}
