import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_export/src/methods/canvas/canvas_image_generator.dart';
import 'package:image_export/src/common/eco_score_badge.dart';
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

  int totalMsA = 0;
  int totalMsB = 0;

  double get averageA => runs == 0 ? 0 : totalMsA / runs;
  double get averageB => runs == 0 ? 0 : totalMsB / runs;

  Future<void> methodA() async {
    await CanvasImageGenerator().generateImage();
  }

  Future<void> methodB() async {
    final imageGenerator = ImageGenerator();
    await imageGenerator.precacheImages(context, images: EcoScoreBadge.images);
    await imageGenerator.generateImageFromWidget(EcoScoreBadge());
  }

  Future<void> compareMethods() async {
    setState(() {
      _isRunning = true;
      totalMsA = 0;
      totalMsB = 0;
    });

    for (int i = 0; i < runs; i++) {
      final stopwatchA = Stopwatch()..start();
      Timeline.startSync('FlutterCanvas Run $i');
      await methodA();
      Timeline.finishSync();
      stopwatchA.stop();
      totalMsA += stopwatchA.elapsedMilliseconds;

      final stopwatchB = Stopwatch()..start();
      Timeline.startSync('RenderRepaintBoundary Run $i');
      await methodB();
      Timeline.finishSync();
      stopwatchB.stop();
      totalMsB += stopwatchB.elapsedMilliseconds;
    }

    setState(() {
      _isRunning = false;
    });
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (averageA > averageB ? averageA : averageB) * 1.3,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('FlutterCanvas');
                  case 1:
                    return const Text('RenderRepaintBoundary');
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: averageA,
                width: 30,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: averageB,
                width: 30,
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Comparison')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : compareMethods,
              child: const Text('Run Comparison'),
            ),
            const SizedBox(height: 24),
            if (_isRunning) const CircularProgressIndicator(),
            if (!_isRunning && totalMsA > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total FlutterCanvas: ${totalMsA}ms'),
                  Text('Avg FlutterCanvas: ${averageA.toStringAsFixed(2)}ms'),
                  const SizedBox(height: 8),
                  Text('Total RenderRepaintBoundary: ${totalMsB}ms'),
                  Text(
                    'Avg RenderRepaintBoundary: ${averageB.toStringAsFixed(2)}ms',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(height: 250, child: _buildBarChart()),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
