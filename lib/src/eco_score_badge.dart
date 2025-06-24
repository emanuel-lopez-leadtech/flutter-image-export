import 'package:flutter/material.dart';

class EcoScoreBadge extends StatelessWidget {
  const EcoScoreBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1980, maxHeight: 1080),
      child: AspectRatio(
        aspectRatio: 1980 / 1080,
        child: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: [
            Image(image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlutterLogo(size: 60.0),
                  Text(
                    'Paperless Certificate',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    'Sprout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade800, width: 1),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              '41',
                              style: TextStyle(
                                color: Colors.red.shade100,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          WidgetSpan(child: SizedBox(width: 10)),
                          TextSpan(
                            text: 'sheets of paper digitalized',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
