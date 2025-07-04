import 'package:flutter/material.dart';
import 'package:image_export/src/comparison/algorithm.dart';

class ComparisonProgress extends StatelessWidget {
  const ComparisonProgress({
    super.key,
    required this.currentAlgorithmIndex,
    required this.currentIteration,
    required this.algorithms,
    required this.runs,
  });

  final int currentAlgorithmIndex;
  final int currentIteration;
  final List<Algorithm> algorithms;
  final int runs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Running: ${algorithms[currentAlgorithmIndex].name}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Iteration: $currentIteration / $runs',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value:
              ((currentAlgorithmIndex + currentIteration * algorithms.length) /
              (runs * algorithms.length)),
        ),
      ],
    );
  }
}
