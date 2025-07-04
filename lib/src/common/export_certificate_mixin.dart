import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

mixin ExportCertificateMixin {
  void export({required Uint8List? bytes, required String format}) async {
    try {
      if (bytes == null) return;

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/certificate.$format');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Check out this widget!');
    } catch (e) {
      debugPrint('Error capturing and sharing: $e');
    }
  }
}
