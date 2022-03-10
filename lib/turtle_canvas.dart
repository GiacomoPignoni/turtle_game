import 'dart:ui';
import 'package:flutter/material.dart';

class TurtleCanvas extends StatefulWidget {
  const TurtleCanvas({Key? key}) : super(key: key);

  @override
  State<TurtleCanvas> createState() => TurtleCanvasState();
}

class TurtleCanvasState extends State<TurtleCanvas> with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final _painterAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.yellow[50],
      child: AnimatedBuilder(
        animation: _painterAnimation,
        builder: (context, snapshot) {
          return CustomPaint(
            painter: TurtleCanvasPainter(
              staticPath: Path()..moveTo(150, 150)..lineTo(50, 50), 
              animatedPath: Path()..moveTo(50, 50)..lineTo(100, 0), 
              animationProgress: _painterAnimation.value
            )
          );
        }
      ),
    );
  }

  toggle() {
    if(_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}

class TurtleCanvasPainter extends CustomPainter {
  final Path staticPath;
  final Path animatedPath;
  final double animationProgress;

  TurtleCanvasPainter({
    required this.staticPath,
    required this.animatedPath,
    required this.animationProgress
  });

  @override
  void paint(Canvas canvas, Size size) {  
    final pathPaint = Paint()
      ..color = Colors.blueGrey[900]!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final partialAnimatedPath = _createAnimatedPath(animatedPath, animationProgress);
    canvas.drawPath(staticPath, pathPaint);
    canvas.drawPath(partialAnimatedPath, pathPaint);

    _drawTurtle(canvas, Offset(size.width/2, size.height/2), 45);
  }

  _drawTurtle(Canvas canvas, Offset position, double angle) {
    final path = Path()
      ..moveTo(position.dx - 10, position.dy + 6)
      ..lineTo(position.dx + 10, position.dy + 6)
      ..lineTo(position.dx, position.dy - 10)
      ..close();
    
    final turtlePaint = Paint()
      ..color = Colors.red[800]!
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, turtlePaint);
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