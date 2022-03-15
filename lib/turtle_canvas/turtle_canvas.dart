import 'package:flutter/material.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_controller.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_painter.dart';
import 'package:turtle_game/turtle_canvas/turtle_cavans_state_model.dart';

class TurtleCanvas extends StatefulWidget {
  final TurtleCanvasController controller;

  const TurtleCanvas({
    required this.controller,
    Key? key
  }) : super(key: key);

  @override
  State<TurtleCanvas> createState() => TurtleCanvasState();
}

class TurtleCanvasState extends State<TurtleCanvas> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.controller.inizializeAnimation(this, const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.yellow[50],
      child: ValueListenableBuilder<TurtleCavnasStateModel>(
        valueListenable: widget.controller.canvasState,
        builder: (context, canvasState, child) {
          return AnimatedBuilder(
            animation: widget.controller.painterAnimation,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: TurtleCanvasPainter(
                  animationProgress: widget.controller.painterAnimation.value,
                  staticPath: canvasState.staticPath,
                  animatedPath: canvasState.toDrawPath, 
                  turtleAngle: canvasState.turtleOrientation,
                  toTurtleAngle: canvasState.toTurtleOrientation
                )
              );
            }
          );
        }
      ),
    );
  }
}
