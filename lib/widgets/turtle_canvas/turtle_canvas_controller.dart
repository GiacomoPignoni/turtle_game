import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas_line.dart';

class TurtleCanvasController {
  bool _inizialized = false;
  late final AnimationController animationController;
  late final Animation<double> painterAnimation;

  final StreamController<void> _animationCompleted = StreamController.broadcast();
  final ValueNotifier<TurtleCanvasDrawModel> drawModel = ValueNotifier(TurtleCanvasDrawModel(
    pathToDraw: Path(),
    lineToAnimate: null,
    turtleAngle: 0,
    toTurtleAngle: 0,
    turtlePosition: const Offset(0, 0)
  ));
  
  void init(TickerProvider tickerProvider) {
    if(_inizialized == false) {
      animationController = AnimationController(
        vsync: tickerProvider,
        duration: const Duration(milliseconds: 1000),
      );

      painterAnimation = Tween<double>(begin: 0, end: 1).animate(animationController);

      animationController.addStatusListener((newState) {
        if(newState == AnimationStatus.completed) {
          _animationCompleted.add(null);
        }
      });
      
      _inizialized = true;
    }
  }
  
  Future<void> draw({
    required Path pathToDraw,
    TurtleCanvasLine? lineToAnimate,
    required double turtleAngle,
    double? toTurtleAngle,
    required Offset turtlePosition
  }) async {
    animationController.reset();

    drawModel.value = drawModel.value.copyWith(
      pathToDraw: pathToDraw,
      lineToAnimate: lineToAnimate,
      turtleAngle: turtleAngle,
      toTurtleAngle: toTurtleAngle ?? turtleAngle,
      turtlePosition: turtlePosition
    );

    animationController.forward();
    await _animationCompleted.stream.first;
  }

  void clear({
    required double turtleAngle,
    required Offset turtlePosition 
  }) {
    drawModel.value = drawModel.value.copyWith(
      pathToDraw: Path(),
      lineToAnimate: null,
      turtleAngle: turtleAngle,
      toTurtleAngle: turtleAngle,
      turtlePosition: turtlePosition
    );
  }

  void pauseAnimation() {
    animationController.stop();
  }

  Future<void> playAnimation() async {
    animationController.forward();
    await _animationCompleted.stream.first;
  }

  void dispose() {
    animationController.dispose();
    _animationCompleted.close();
  }
}

class TurtleCanvasDrawModel {
  final Path pathToDraw;
  final TurtleCanvasLine? lineToAnimate;
  final double turtleAngle;
  final double toTurtleAngle;
  final Offset turtlePosition;

  TurtleCanvasDrawModel({
    required this.pathToDraw,
    required this.lineToAnimate,
    required this.turtleAngle,
    required this.toTurtleAngle,
    required this.turtlePosition
  });

  TurtleCanvasDrawModel copyWith({
    Path? pathToDraw,
    TurtleCanvasLine? lineToAnimate,
    double? turtleAngle,
    double? toTurtleAngle,
    Offset? turtlePosition
  }) {
    return TurtleCanvasDrawModel(
      pathToDraw: pathToDraw ?? this.pathToDraw,
      lineToAnimate: lineToAnimate,
      turtleAngle: turtleAngle ?? this.turtleAngle,
      toTurtleAngle: toTurtleAngle ?? this.toTurtleAngle,
      turtlePosition: turtlePosition ?? this.turtlePosition
    );
  }
}
