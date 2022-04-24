// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ScreenUtils {
  static const MIN_HORIZONTAL_WIDTH = 750.0;
  static const MIN_HORIZONTAL_HEIGHT = 500.0;

  static const PORTRAIT_MAX_ASPECT_RATIO = 0.6;

  static bool isPortrait(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final aspectRatio = mediaQuery.size.width / mediaQuery.size.height;

    return aspectRatio <= PORTRAIT_MAX_ASPECT_RATIO;
  }

  static bool isHorizontal(double screenMaxWidth) {
    return screenMaxWidth > MIN_HORIZONTAL_WIDTH;
  }

  static Future<void> toggleSmartphoneView() async {
    const smartphoneSize = Size(720, 1280);
    final screenSize = await windowManager.getSize();

    if(screenSize == smartphoneSize) {
      windowManager.setSize(const Size(MIN_HORIZONTAL_WIDTH + 20, MIN_HORIZONTAL_HEIGHT));
    } else {
      windowManager.setSize(smartphoneSize);
    }
  }
}
