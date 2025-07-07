import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class BackgroundImage {
  String get path;

  Future<void> loadImage();

  pw.Widget buildBackground();
}

class JpgBackgroundImage extends BackgroundImage {
  late final ByteData _backgoundImage;

  @override
  String get path => 'assets/bg.jpg';

  @override
  Future<void> loadImage() async {
    _backgoundImage = await rootBundle.load('assets/bg.jpg');
  }

  @override
  pw.Widget buildBackground() => pw.Image(
    pw.MemoryImage(_backgoundImage.buffer.asUint8List()),
    fit: pw.BoxFit.cover,
  );
}

class SvgBackgroundImage extends BackgroundImage {
  late final String _backgroundImage;

  @override
  String get path => 'assets/cert_bg_min.svg';

  @override
  Future<void> loadImage() async {
    _backgroundImage = await rootBundle.loadString(path);
  }

  @override
  pw.Widget buildBackground() =>
      pw.SvgImage(svg: _backgroundImage, fit: pw.BoxFit.cover);
}

class PdfGenerator {
  Future<Uint8List> generatePdf(BackgroundImage bg) async {
    await bg.loadImage();

    final pw.Document pdf = pw.Document()
      ..addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(
            width: 990,
            height: 660,
            marginBottom: 0,
            marginTop: 0,
            marginLeft: 0,
            marginRight: 0,
          ),
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Positioned.fill(child: bg.buildBackground()),
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
