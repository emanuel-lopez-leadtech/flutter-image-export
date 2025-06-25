import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

mixin ExportImageMixin {
  void exportImage(Uint8List? bytes) async {
    try {
      if (bytes == null) return;

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/widget_image.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Check out this widget!');
    } catch (e) {
      debugPrint('Error capturing and sharing: $e');
    }
  }
}
