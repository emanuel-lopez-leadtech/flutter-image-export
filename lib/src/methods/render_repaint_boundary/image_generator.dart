import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ImageGenerator {
  /// Renders the given [widget] offscreen to a PNG image.
  /// Ensures any AssetImages inside the widget are precached before rendering.
  ///
  /// [pixelRatio] controls the resolution of the output image (higher means sharper).
  Future<Uint8List?> generateImageFromWidget(
    Widget widget, {
    double pixelRatio = 3.0,
  }) async {
    // Create a repaint boundary which will hold the rendered widget and allow capturing its image.
    final repaintBoundary = RenderRepaintBoundary();

    // Get the current Flutter view (represents the main display).
    final flutterView = WidgetsBinding.instance.platformDispatcher.views.first;

    // Create a RenderView, the root of the render tree, with the configuration of the current FlutterView.
    final renderView = RenderView(
      view: flutterView,
      configuration: ViewConfiguration.fromView(flutterView),
      // Center the repaint boundary inside the render tree.
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
    );

    // PipelineOwner manages the render pipeline phases: layout, compositing, painting.
    final pipelineOwner = PipelineOwner();

    // BuildOwner manages building the widget tree into the render tree.
    final buildOwner = BuildOwner(focusManager: FocusManager());

    // Assign the renderView as the root node of the rendering pipeline.
    pipelineOwner.rootNode = renderView;

    // Attach the widget wrapped in Directionality (required for text direction) to the repaint boundary.
    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(textDirection: TextDirection.ltr, child: widget),
    ).attachToRenderTree(buildOwner);

    // Prepare the render view for the initial frame.
    renderView.prepareInitialFrame();

    // Build the widget tree.
    buildOwner.buildScope(rootElement);

    // Finalize the widget tree construction.
    buildOwner.finalizeTree();

    // Perform layout calculation (sizes and positions).
    pipelineOwner.flushLayout();

    // Update compositing bits.
    pipelineOwner.flushCompositingBits();

    // Paint the render tree into an offscreen buffer.
    pipelineOwner.flushPaint();

    // Capture the image from the repaint boundary at the requested pixel ratio.
    final image = await repaintBoundary.toImage(pixelRatio: pixelRatio);

    // Convert the captured image to PNG byte data.
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    // Return the PNG bytes or null if conversion failed.
    return byteData?.buffer.asUint8List();
  }

  // Precache all AssetImages inside the widget to ensure they are loaded before capture.
  Future<void> precacheImages(
    BuildContext context, {
    required List<String> images,
  }) async {
    final futures = <Future>[];
    for (final image in images) {
      futures.add(precacheImage(AssetImage(image), context));
    }

    await Future.wait(futures);
  }
}
