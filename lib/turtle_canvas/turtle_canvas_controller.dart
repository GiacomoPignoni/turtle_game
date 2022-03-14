import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:turtle_game/models/commands.dart';

class TurtleCanvasController {
  bool _animationInizialized = false;
  late final AnimationController _animationController;
  late final Animation<double> painterAnimation;

  final StreamController<void> _animationCompleted = StreamController<void>();

  bool _running = false;

  inizializeAnimation(TickerProvider tickerProvider, Duration duration) {
    if(_animationInizialized == false) {
      _animationController = AnimationController(
        vsync: tickerProvider,
        duration: duration,
      );

      _animationController.addStatusListener((newState) {
        if(newState == AnimationStatus.completed) {
          _animationCompleted.add(null);
        }
      });

      painterAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

      _animationInizialized = true;
    }
  }

  play(List<Command> commands) async {
    if(_running == false) {
      _running = true;

      for(final command in commands) {
        switch(command.runtimeType) {
          case Forward:
            break;
          case Rotate:
            break;
        }

        await _animationCompleted.stream.single;
      }
    }
  }
}