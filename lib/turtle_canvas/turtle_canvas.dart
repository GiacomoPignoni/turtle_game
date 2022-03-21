import 'dart:async';
import 'package:flutter/material.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_line.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_painter.dart';

class TurtleCanvas extends StatefulWidget {
  final Alignment alignment;

  const TurtleCanvas({ 
    Key? key,
    this.alignment = Alignment.center
  }) : super(key: key);

  @override
  State<TurtleCanvas> createState() => TurtleCanvasState();
}

class TurtleCanvasState extends State<TurtleCanvas> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final Animation<double> _painterAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

  final StreamController<void> _animationCompleted = StreamController.broadcast();

  Path pathToDraw = Path();
  TurtleCanvasLine? lineToAnimate;
  double turtleAngle = 0;
  double toTurtleAngle = 0;
  Offset turtlePosition = const Offset(0, 0);

  @override
  void initState() {
    _animationController.addStatusListener((newState) {
      if(newState == AnimationStatus.completed) {
        _animationCompleted.add(null);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Colors.yellow[50],
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: TurtleCanvasPainter(
                animationProgress: _painterAnimation.value,
                alignment: widget.alignment,
                pathToDraw: pathToDraw,
                lineToAnimate: lineToAnimate, 
                turtleAngle: turtleAngle,
                toTurtleAngle: toTurtleAngle,
                turtlePosition: turtlePosition
              )
            );
          }
        )
      ),
    );
  }

  Future<void> draw({
    required Path pathToDraw,
    TurtleCanvasLine? lineToAnimate,
    required double turtleAngle,
    double? toTurtleAngle,
    required Offset turtlePosition
  }) async {
    _animationController.reset();
    setState(() {
      this.pathToDraw = pathToDraw;
      this.lineToAnimate = lineToAnimate;
      this.turtleAngle = turtleAngle;
      this.toTurtleAngle = toTurtleAngle ?? turtleAngle;
      this.turtlePosition = turtlePosition;
    });
    _animationController.forward();

    await _animationCompleted.stream.first;
  }

  clear({
    required double turtleAngle,
    required Offset turtlePosition 
  }) {
    setState(() {
      this.turtleAngle = turtleAngle;
      this.turtlePosition = turtlePosition;

      pathToDraw = Path();
      lineToAnimate = null;
      toTurtleAngle = turtleAngle;
    });
  }
}
