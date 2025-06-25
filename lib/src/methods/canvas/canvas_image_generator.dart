import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CanvasImageGenerator {
  Future<ui.Image> _loadUiImageFromAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List list = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(list);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  // Text painter helper
  TextPainter textPainter(
    String text,
    double fontSize,
    Color color, {
    FontWeight weight = FontWeight.normal,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, color: color, fontWeight: weight),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    return tp;
  }

  Future<void> _drawBackgound({
    required Canvas canvas,
    required int width,
    required int height,
  }) async {
    // Load the background image
    final backgroundImage = await _loadUiImageFromAsset('assets/bg.jpg');

    // Draw background using BoxFit.cover logic
    final bgSize = Size(
      backgroundImage.width.toDouble(),
      backgroundImage.height.toDouble(),
    );
    final outputSize = Size(width.toDouble(), height.toDouble());
    final fittedSizes = applyBoxFit(BoxFit.cover, bgSize, outputSize);
    final src = Offset.zero & fittedSizes.source;
    final dst = Alignment.center.inscribe(
      fittedSizes.destination,
      Offset.zero & outputSize,
    );

    canvas.drawImageRect(backgroundImage, src, dst, Paint());
  }

  Future<void> _drawAppIcon({
    required Canvas canvas,
    required Offset center,
    required double iconSize,
    required double scale,
    required double y,
  }) async {
    final appIcon = await _loadUiImageFromAsset('assets/scanshot.png');
    canvas.drawImageRect(
      appIcon,
      Rect.fromLTWH(
        0,
        0,
        appIcon.width.toDouble(),
        appIcon.height.toDouble(),
      ), // full image
      Rect.fromLTWH(
        center.dx - iconSize / 2,
        y,
        iconSize,
        iconSize,
      ), // scale and center
      Paint(),
    );
  }

  Future<void> _drawCounterBadge({
    required Canvas canvas,
    required double scale,
    required Offset center,
    required double y,
  }) async {
    // Badge
    final badgePadding = 8.0 * scale;
    final number = textPainter('41', 20 * scale, Colors.red.shade100);
    final label = textPainter(
      'sheets of paper digitalized',
      15 * scale,
      Colors.white,
    );

    final badgeWidth =
        number.width + (10 * scale) + label.width + badgePadding * 2;
    final badgeHeight = max(number.height, label.height) + badgePadding * 2;

    // Update badge corner radius:
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, y + badgeHeight / 2),
        width: badgeWidth,
        height: badgeHeight,
      ),
      Radius.circular(16 * scale),
    );

    canvas.drawRRect(badgeRect, Paint()..color = Colors.red.shade400);
    canvas.drawRRect(
      badgeRect,
      Paint()
        ..color = Colors.red.shade800
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Draw text inside badge
    final textX = center.dx - badgeWidth / 2 + badgePadding;
    final textY = y + badgePadding;
    number.paint(canvas, Offset(textX, textY));
    label.paint(canvas, Offset(textX + number.width + 10, textY + 12));
  }

  Future<Uint8List?> generateImage() async {
    Uint8List? result;
    try {
      const double scale = 6;
      const width = 1980;
      const height = 1080;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      );

      await _drawBackgound(canvas: canvas, width: width, height: height);

      final center = Offset(width / 2, height / 2);
      double y = center.dy - 480;

      final iconSize = 60.0 * scale;
      await _drawAppIcon(
        canvas: canvas,
        center: center,
        iconSize: iconSize,
        scale: scale,
        y: y,
      );

      y += iconSize + (10 * scale);

      final tp1 = textPainter(
        'Paperless Certificate',
        15 * scale,
        Colors.white,
      );
      tp1.paint(canvas, Offset(center.dx - tp1.width / 2, y));

      y += tp1.height + 4;

      final tp2 = textPainter(
        'Sprout',
        25 * scale,
        Colors.white,
        weight: FontWeight.bold,
      );
      tp2.paint(canvas, Offset(center.dx - tp2.width / 2, y));

      y += tp2.height + 12;

      await _drawCounterBadge(
        canvas: canvas,
        scale: scale,
        center: center,
        y: y,
      );

      // Finalize the picture.
      final ui.Picture picture = recorder.endRecording();
      // Convert the Picture to an Image.
      final ui.Image finalImage = await picture.toImage(width, height);
      // Convert the Image to PNG bytes.
      final ByteData? byteData = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData != null) {
        result = byteData.buffer.asUint8List();
      }
    } catch (e) {
      debugPrint("An error occurred during PNG generation: $e");
    }
    return result;
  }
}
