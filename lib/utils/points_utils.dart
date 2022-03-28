import 'dart:math';

import 'package:flutter/painting.dart';

class PointsUtils {
  static Offset newPointFromDistance(Offset startPoint, double angle, double distance) {
    final newX = startPoint.dx + (distance * cos(angle * pi/180));
    final newY = startPoint.dy + (distance * sin(angle * pi/180));

    return Offset(newX, newY);
  }
}
