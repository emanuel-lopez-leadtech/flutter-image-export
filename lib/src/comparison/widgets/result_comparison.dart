import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_export/src/comparison/algorithm.dart';

class ResultComparison extends StatelessWidget {
  const ResultComparison({
    super.key,
    required this.algorithms,
    required this.totalMs,
    required this.averages,
  });

  final List<Algorithm> algorithms;
  final List<int> totalMs;
  final List<double> averages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < algorithms.length; i++) ...[
          Text('Total ${algorithms[i].name}: ${totalMs[i]}ms'),
          Text(
            'Avg ${algorithms[i].name}: ${averages[i].toStringAsFixed(2)}ms',
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 24),
        SizedBox(height: 250, child: _buildBarChart()),
        const SizedBox(height: 16),
        _buildXLegends(),
      ],
    );
  }

  Widget _buildBarChart() {
    final double maxY = averages.isEmpty
        ? 0
        : (averages.reduce((a, b) => a > b ? a : b)) * 1.3;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide X legends here
          ),
        ),
        barGroups: [
          for (int i = 0; i < algorithms.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: averages[i],
                  width: 30,
                  color: algorithms[i].color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildXLegends() {
    return Column(
      spacing: 8,
      children: [
        for (int i = 0; i < algorithms.length; i++)
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: algorithms[i].color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                algorithms[i].name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
      ],
    );
  }
}
