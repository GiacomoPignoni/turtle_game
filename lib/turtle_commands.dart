import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:turtle_game/models/commands.dart';
import 'package:turtle_game/models/pair.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_controller.dart';

class TurtleCommands extends ChangeNotifier {
  final TurtleCanvasController _turtleCanvasController;

  final List<Command> commands = [
    Forward(50),
    Rotate(90),
    Forward(50)
  ];

  bool _running = false;
  final List<Pair<Offset, Offset>> _drawedLines = [];
  Offset _currentPosition = const Offset(0, 0);
  double _currentTurtleAngle = 0;
  Pair? _animatingPair;

  TurtleCommands(this._turtleCanvasController);

  Future<void> play() async {
    if(_running == false) {
      _running = true;

      _turtleCanvasController.clear();
      for(final command in commands) {
        switch(command.runtimeType) {
          case Forward:
            _forward((command as Forward).distance);
            break;
          case Rotate:
            _rotate((command as Rotate).rotation);
            break;
        }
      }

      _running = false;
    }
  }

  reset() {
    _turtleCanvasController.clear();
  }

  Future<void> _forward(int distance) async {
    final newX = _currentPosition.dx + (distance * cos(_currentTurtleAngle * pi/180));
    final newY = _currentPosition.dy + (distance * sin(_currentTurtleAngle * pi/180));

    _turtleCanvasController.draw(
      linesToDraw: _drawedLines, 
      turtleAngle: _currentTurtleAngle
    );

    _currentPosition = Offset(newX, newY);
  }

  Future<void> _rotate(double rotation) async {
    _turtleCanvasController.draw(
      linesToDraw: _drawedLines,
      turtleAngle: _currentTurtleAngle,
      toTurtleAngle: _currentTurtleAngle + rotation
    );
  }
}
