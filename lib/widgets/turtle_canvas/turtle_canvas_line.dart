import 'dart:math';

import 'package:flutter/cupertino.dart';

class TurtleCanvasLine {
  final Offset startPoint;
  final Offset endPoint;

  TurtleCanvasLine({
    required this.startPoint,
    required this.endPoint
  });

  Offset calculatePartialEndPoint(double percentage) {
    final partialDistance = distance() * percentage;
    final radian = angle();
    return Offset(
      partialDistance * cos(radian) + startPoint.dx,
      partialDistance * sin(radian) + startPoint.dy
    );
  }

  double distance() {
    return sqrt(pow(endPoint.dx - startPoint.dx, 2) + pow(endPoint.dy - startPoint.dy, 2));
  }

  double angle() {
    return atan2(endPoint.dy - startPoint.dy, endPoint.dx - startPoint.dx);
  }
}
