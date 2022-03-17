import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:turtle_game/models/commands.dart';
import 'package:turtle_game/turtle_canvas/turtle_cavans_state_model.dart';

class TurtleCanvasController {
  bool _animationInizialized = false;
  late final AnimationController _animationController;
  late final Animation<double> painterAnimation;

  final StreamController<bool> _animationCompleted = StreamController.broadcast();
  late final ValueNotifier<TurtleCavnasStateModel> canvasState = ValueNotifier(TurtleCavnasStateModel(
    staticPath: Path()..moveTo(0, 0),
    toDrawPath: null,
    turtleOrientation: 0,
    toTurtleOrientation: 0
  ));

  Offset _currentPosition = const Offset(0, 0);

  bool _running = false;

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

  Future<void> execCommand(Command command) async {
    if(_running == false) {
      _running = true;

      if(canvasState.value.toDrawPath != null) {
        canvasState.value.staticPath.addPath(canvasState.value.toDrawPath!, const Offset(0, 0)); 
      }
      canvasState.value.turtleOrientation = canvasState.value.toTurtleOrientation;

      switch(command.runtimeType) {
        case Forward:
          _forward((command as Forward).distance);
          break;
        case Rotate:
          _rotate((command as Rotate).rotation);
          break;
      }

      _animationController.reset();
      _animationController.forward();

      await _animationCompleted.stream.first;
      _running = false;
    }
  }

  reset() {
    canvasState.value = TurtleCavnasStateModel(
      staticPath: Path()..moveTo(0, 0),
      toDrawPath: null,
      turtleOrientation: 0,
      toTurtleOrientation: 0
    );
    _currentPosition = const Offset(0, 0);
  }

  _forward(int distance) {
    final newX = _currentPosition.dx + (distance * cos(canvasState.value.toTurtleOrientation * pi/180));
    final newY = _currentPosition.dy + (distance * sin(canvasState.value.toTurtleOrientation * pi/180));

    canvasState.value = canvasState.value.copyWith(
      toDrawPath: Path()..moveTo(_currentPosition.dx, _currentPosition.dy)..lineTo(newX, newY)
    );
    _currentPosition = Offset(newX, newY);
  }

  _rotate(double rotation) {
    canvasState.value = canvasState.value.copyWith(
      toTurtleOrientation: canvasState.value.turtleOrientation + rotation,
      toDrawPath: null
    );
  }
  
  draw() {

  }

  clear() {
    
  }
}
