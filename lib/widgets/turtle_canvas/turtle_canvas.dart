import 'package:flutter/material.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas_controller.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas_painter.dart';

class TurtleCanvas extends StatefulWidget {
  final Alignment alignment;
  final TurtleCanvasController controller;

  const TurtleCanvas({ 
    Key? key,
    required this.controller,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  State<TurtleCanvas> createState() => TurtleCanvasState();
}

class TurtleCanvasState extends State<TurtleCanvas> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget.controller.init(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Colors.yellow[50],
        child: AnimatedBuilder(
          animation: widget.controller.animationController,
          builder: (context, snapshot) {
            return ValueListenableBuilder<TurtleCanvasDrawModel>(
             valueListenable: widget.controller.drawModel,
              builder: (context, drawModel, child) {
                return CustomPaint(
                  painter: TurtleCanvasPainter(
                    animationProgress:  widget.controller.painterAnimation.value,
                    alignment: widget.alignment,
                    pathToDraw: drawModel.pathToDraw,
                    lineToAnimate: drawModel.lineToAnimate, 
                    turtleAngle: drawModel.turtleAngle,
                    toTurtleAngle: drawModel.toTurtleAngle,
                    turtlePosition: drawModel.turtlePosition
                  )
                );
              }
            );
          }
        )
      ),
    );
  }
}
