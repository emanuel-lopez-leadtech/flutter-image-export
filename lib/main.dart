import 'package:flutter/material.dart';
import 'package:image_export/src/screen_shot_screen.dart';
import 'package:image_export/src/widget_to_image_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget to Image POC',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScreenShotScreen(),
    );
  }
}
