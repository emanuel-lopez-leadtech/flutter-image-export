import 'package:flutter/material.dart';
import 'package:image_export/src/methods/canvas/canvas_screen.dart';
import 'package:image_export/src/methods/pdf/pdf_generator.dart';
import 'package:image_export/src/methods/pdf/pdf_screen.dart';
import 'package:image_export/src/comparison/performance_comparison_screen.dart';
import 'package:image_export/src/methods/render_repaint_boundary/render_repaint_boundary_screen.dart';
import 'package:image_export/src/methods/screenshot/screen_shot_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, {required Widget screen}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image generator')),
      body: ListView(
        children: [
          ListTile(
            title: Text('ScreenShot package'),
            subtitle: Text('Uses the screenshot package'),
            onTap: () => _navigateTo(context, screen: ScreenShotScreen()),
          ),
          ListTile(
            title: Text('Flutter Canvas'),
            subtitle: Text('Uses Flutter Canvas'),
            onTap: () => _navigateTo(context, screen: CanvasScreen()),
          ),
          ListTile(
            title: Text('RenderRepaintBoundary'),
            subtitle: Text('Uses RenderRepaintBoundary'),
            onTap: () =>
                _navigateTo(context, screen: RenderRepaintBoundaryScreen()),
          ),
          ListTile(
            title: Text('Pdf using JPG background'),
            subtitle: Text('Creates a PDF certificate'),
            onTap: () => _navigateTo(
              context,
              screen: PdfScreen(bg: JpgBackgroundImage()),
            ),
          ),
          ListTile(
            title: Text('Pdf using SVG background'),
            subtitle: Text('Creates a PDF certificate'),
            onTap: () => _navigateTo(
              context,
              screen: PdfScreen(bg: SvgBackgroundImage()),
            ),
          ),
          ListTile(
            title: Text('PerformanceComparisonScreen'),
            subtitle: Text(
              'Compares performance between RenderRepaintBoundary and FlutterCanvas',
            ),
            onTap: () =>
                _navigateTo(context, screen: PerformanceComparisonScreen()),
          ),
        ],
      ),
    );
  }
}
