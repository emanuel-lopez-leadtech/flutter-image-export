import 'package:flutter/material.dart';

class Algorithm {
  final String name;
  final Color color;
  final Future<void> Function(BuildContext context) run;

  Algorithm({required this.name, required this.color, required this.run});
}
