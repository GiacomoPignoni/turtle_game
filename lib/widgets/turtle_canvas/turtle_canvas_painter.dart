import 'dart:math';
import 'package:flutter/material.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas_line.dart';

class TurtleCanvasPainter extends CustomPainter {
  final double animationProgress;
  final Path pathToDraw;
  final TurtleCanvasLine? lineToAnimate;
  final double turtleAngle;
  final double toTurtleAngle;
  final Offset turtlePosition;
  final Alignment alignment;
  final double turtleDimension;

  TurtleCanvasPainter({
    required this.animationProgress,
    required this.pathToDraw,
    required this.turtleAngle,
    required this.toTurtleAngle,
    required this.turtlePosition,
    required this.alignment,
    required this.turtleDimension,
    this.lineToAnimate
  });

  @override
  void paint(Canvas canvas, Size size) {  
    final linePaint = Paint()
      ..color = Colors.blueGrey[900]!
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    //Draw static path
    final alignmentOffset = _calculateAlinmentOffset(size);
    canvas.drawPath(pathToDraw.shift(alignmentOffset), linePaint);
    Offset realTurtlePosition = turtlePosition + alignmentOffset;

    //Calculate and draw animate line
    if(lineToAnimate != null) {
      final partialEndPoint = lineToAnimate!.calculatePartialEndPoint(animationProgress);

      canvas.drawLine(
        lineToAnimate!.startPoint + alignmentOffset,
        partialEndPoint + alignmentOffset,
        linePaint
      );

      realTurtlePosition = partialEndPoint + alignmentOffset;
    }

    //Calculate turtle angle
    double calculatedTurtleAngle = turtleAngle;
    if(turtleAngle != toTurtleAngle) {
      calculatedTurtleAngle = turtleAngle + ((toTurtleAngle - turtleAngle) * animationProgress);
    }
    _drawTurtle(canvas, realTurtlePosition, calculatedTurtleAngle * (pi / 180));
  }

  _drawTurtle(Canvas canvas, Offset position, double radianAngle) {
    final turtlePaint = Paint()
      ..color = Colors.red[800]!
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final frontPointPaint = Paint()
      ..color = Colors.blue;

    final radius = turtleDimension / sqrt(3);
    final frontPoint = Offset(radius * cos(radianAngle) + position.dx, radius * sin(radianAngle) + position.dy);
    final path = Path()
      ..moveTo(frontPoint.dx, frontPoint.dy)
      ..lineTo(radius * cos(radianAngle + (4 * pi / 3)) + position.dx, radius * sin(radianAngle + (4 * pi / 3)) + position.dy)
      ..lineTo(radius * cos(radianAngle + (2 * pi / 3)) + position.dx, radius * sin(radianAngle + (2 * pi / 3)) + position.dy)
      ..close();

    canvas.drawPath(path, turtlePaint);
    canvas.drawCircle(frontPoint, 2, frontPointPaint);
  }

  _calculateAlinmentOffset(Size size) {
    final centerX = size.width / 2;
    final centerY = size.height /2;
    return Offset(centerX, centerY) + Offset(alignment.x * centerX, alignment.y * centerY);
  }

  @override
  bool shouldRepaint(covariant TurtleCanvasPainter oldDelegate) => true;
}
