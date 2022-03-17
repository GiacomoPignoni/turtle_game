import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:turtle_game/models/pair.dart';
import 'package:turtle_game/turtle_canvas/turtle_cavans_state_model.dart';

class TurtleCanvasController {
  bool _animationInizialized = false;
  late final AnimationController _animationController;
  late final Animation<double> painterAnimation;

  final StreamController<bool> _animationCompleted = StreamController.broadcast();
  late final ValueNotifier<TurtleCavnasStateModel> canvasState = ValueNotifier(TurtleCavnasStateModel(
    linesToDraw: [],
    toAnimatePath: null,
    turtleAngle: 0,
    toTurtleAngle: 0
  ));

  inizializeAnimation(TickerProvider tickerProvider, Duration duration) {
    if(_animationInizialized == false) {
      _animationController = AnimationController(
        vsync: tickerProvider,
        duration: duration,
      );

      _animationController.addStatusListener((newState) {
        if(newState == AnimationStatus.completed) {
          _animationCompleted.add(true);
        }
      });

      painterAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

      _animationInizialized = true;
    }
  }

  draw({
    required List<Pair<Offset, Offset>> linesToDraw, 
    Path? toAnimatePath,
    required double turtleAngle,
    double? toTurtleAngle
  }) {
    canvasState.value = canvasState.value.copyWith(
      linesToDraw: linesToDraw,
      toAnimatePath: toAnimatePath,
      turtleAngle: turtleAngle,
      toTurtleAngle: toTurtleAngle
    );
  }

  clear() {
    canvasState.value = TurtleCavnasStateModel(
      linesToDraw: [],
      toAnimatePath: null,
      turtleAngle: 0,
      toTurtleAngle: 0
    );
  }
}
