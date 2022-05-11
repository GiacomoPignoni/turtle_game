// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

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
}
