import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_export/src/comparison/algorithm.dart';
import 'package:image_export/src/comparison/widgets/comparison_progress.dart';
import 'package:image_export/src/comparison/widgets/result_comparison.dart';
import 'package:image_export/src/methods/canvas/canvas_image_generator.dart';
import 'package:image_export/src/common/eco_score_badge.dart';
import 'package:image_export/src/methods/pdf/pdf_generator.dart';
import 'package:image_export/src/methods/render_repaint_boundary/image_generator.dart';

class PerformanceComparisonScreen extends StatefulWidget {
  const PerformanceComparisonScreen({super.key});

  @override
  State<PerformanceComparisonScreen> createState() =>
      _PerformanceComparisonScreenState();
}

class _PerformanceComparisonScreenState
    extends State<PerformanceComparisonScreen> {
  bool _isRunning = false;
  int runs = 20;

  int currentAlgorithmIndex = 0;
  int currentIteration = 0;

  final List<Algorithm> algorithms = [
    Algorithm(
      name: 'FlutterCanvas',
      color: Colors.blue,
      run: (BuildContext context) async =>
          await CanvasImageGenerator().generateImage(),
    ),
    Algorithm(
      name: 'RenderRepaintBoundary',
      color: Colors.green,
      run: (BuildContext context) async {
        final imageGenerator = ImageGenerator();
        await imageGenerator.precacheImages(
          context,
          images: EcoScoreBadge.images,
        );
        await imageGenerator.generateImageFromWidget(EcoScoreBadge());
      },
    ),
    Algorithm(
      name: 'PDF Export',
      color: Colors.red,
      run: (BuildContext context) async {
        await PdfGenerator().generatePdf();
      },
    ),
  ];

  late List<int> totalMs;
  late List<double> averages;

  @override
  void initState() {
    super.initState();
    totalMs = List.filled(algorithms.length, 0);
    averages = List.filled(algorithms.length, 0);
  }

  Future<void> compareMethods() async {
    setState(() {
      _isRunning = true;
      totalMs = List.filled(algorithms.length, 0);
      averages = List.filled(algorithms.length, 0);
      currentAlgorithmIndex = 0;
      currentIteration = 0;
    });

    for (int i = 0; i < runs; i++) {
      for (int j = 0; j < algorithms.length; j++) {
        setState(() {
          currentAlgorithmIndex = j;
          currentIteration = i + 1;
        });
        final stopwatch = Stopwatch()..start();
        Timeline.startSync('${algorithms[j].name} Run $i');
        await algorithms[j].run(context);
        Timeline.finishSync();
        stopwatch.stop();
        totalMs[j] += stopwatch.elapsedMilliseconds;
      }
    }

    setState(() {
      averages = [
        for (int j = 0; j < algorithms.length; j++)
          runs == 0 ? 0 : totalMs[j] / runs,
      ];
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Comparison')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : compareMethods,
              child: const Text('Run Comparison'),
            ),
            const SizedBox(height: 24),
            if (_isRunning)
              ComparisonProgress(
                currentAlgorithmIndex: currentAlgorithmIndex,
                currentIteration: currentIteration,
                algorithms: algorithms,
                runs: runs,
              ),
            if (!_isRunning && totalMs.any((ms) => ms > 0))
              ResultComparison(
                algorithms: algorithms,
                totalMs: totalMs,
                averages: averages,
              ),
          ],
        ),
      ),
    );
  }
}
