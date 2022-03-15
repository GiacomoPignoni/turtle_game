import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class TurtleCanvasPainter extends CustomPainter {
  final double animationProgress;
  final Path staticPath;
  final Path? animatedPath;
  final double turtleAngle;
  final double toTurtleAngle;

  TurtleCanvasPainter({
    required this.animationProgress,
    required this.staticPath,
    required this.animatedPath,
    required this.turtleAngle,
    required this.toTurtleAngle
  });

  @override
  void paint(Canvas canvas, Size size) {  
    final pathPaint = Paint()
      ..color = Colors.blueGrey[900]!
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final shiftedStaticPath =  staticPath.shift(Offset(size.width / 2, size.height / 2));
    shiftedStaticPath.close();
    canvas.drawPath(shiftedStaticPath, pathPaint);

    final shiftedStaticPathRect = shiftedStaticPath.getBounds();
    Offset turtlePosition = Offset(shiftedStaticPathRect.right, shiftedStaticPathRect.left);

    if(animatedPath != null) {
      final shiftedAnimatedPath = animatedPath!.shift(Offset(size.width / 2, size.height / 2));
      final partialAnimatedPath = _createAnimatedPath(shiftedAnimatedPath, animationProgress);
      canvas.drawPath(partialAnimatedPath, pathPaint);

      final partialAnimatedPathRect = partialAnimatedPath.getBounds();
      turtlePosition = Offset(partialAnimatedPathRect.right, partialAnimatedPathRect.left);
    }

    double calculatedTurtleAngle = turtleAngle;
    // If turtleAngle is differnt from toTurtleAngle I have to animate the rotation 
    if(turtleAngle != toTurtleAngle) {
      calculatedTurtleAngle = turtleAngle + ((toTurtleAngle - turtleAngle) * animationProgress);
    }
    _drawTurtle(canvas, turtlePosition, calculatedTurtleAngle * (pi / 180));
  }

  _drawTurtle(Canvas canvas, Offset position, double radianAngle) {
    const turtleDimension = 15;
    final radius = turtleDimension / sqrt(3);

    final frontPoint = Offset(radius * cos(radianAngle) + position.dx, radius * sin(radianAngle) + position.dy);
    final path = Path()
      ..moveTo(frontPoint.dx, frontPoint.dy)
      ..lineTo(radius * cos(radianAngle + (4 * pi / 3)) + position.dx, radius * sin(radianAngle + (4 * pi / 3)) + position.dy)
      ..lineTo(radius * cos(radianAngle + (2 * pi / 3)) + position.dx, radius * sin(radianAngle + (2 * pi / 3)) + position.dy)
      ..close();
    
    final turtlePaint = Paint()
      ..color = Colors.red[800]!
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final frontPointPaint = Paint()
      ..color = Colors.blue;

    canvas.drawPath(path, turtlePaint);
    canvas.drawCircle(frontPoint, 2, frontPointPaint);
  }

  Path _createAnimatedPath(Path originalPath, double animationPercent) {
    final totalLength = originalPath.computeMetrics()
      .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    final currentLength = totalLength * animationPercent;

    return _extractPathUntilLength(originalPath, currentLength);
  }

  Path _extractPathUntilLength(Path originalPath, double length) {
    var currentLength = 0.0;
    final path = Path();
    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant TurtleCanvasPainter oldDelegate) => true;
}
