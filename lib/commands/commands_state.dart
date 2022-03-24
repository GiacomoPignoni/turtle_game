import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:turtle_game/commands/command_models.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_controller.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_line.dart';

class CommandsState extends ChangeNotifier {
  final TurtleCanvasController turtleCanvasController = TurtleCanvasController();

  final List<Command> commands = [
    Forward(50),
    Rotate(45),
    Forward(50),
    Rotate(45),
    Forward(50)
  ];

  final ValueNotifier<bool> running = ValueNotifier(false);

  Path _drawedPath = Path();
  double _currentTurtleAngle = 0;
  Offset _currentPosition = const Offset(0, 0);
  int _currentCommandIndex = -1;

  reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Command command = commands.removeAt(oldIndex);
    commands.insert(newIndex, command);
    notifyListeners();
  }

  insert(Command command, int index) {
    commands.insert(index, command);
    notifyListeners();
  }

  Future<void> play() async {
    if(running.value == false) {
      running.value = true;
      reset();

      for(final command in commands) { 
        await _execCommand(command);
      }

      running.value = false;
    }
  }

  Future<void> onStep() async {
    if(running.value == false) {
      running.value = true;

      if(_currentCommandIndex == -1) {
        _currentCommandIndex = 0;
      }

      await _execCommand(commands[_currentCommandIndex]);
      _currentCommandIndex++;
      running.value = false;
    }
  }

  reset() {
    if(running.value == false) {
      _currentCommandIndex = -1;
      _drawedPath = Path();
      _currentTurtleAngle = 0;
      _currentPosition = const Offset(0, 0);
      turtleCanvasController.clear(
        turtleAngle: _currentTurtleAngle,
        turtlePosition: _currentPosition
      );
    }
  }

  Future<void> _execCommand(Command command) async {
    switch(command.runtimeType) {
      case Forward:
        final newLine = await _forward((command as Forward).distance);
        _updateDrawedPath(newLine);
        break;
      case Rotate:
        await _rotate((command as Rotate).rotation);
        break;
    }
  }

  Future<TurtleCanvasLine> _forward(int distance) async {
    final newX = _currentPosition.dx + (distance * cos(_currentTurtleAngle * pi/180));
    final newY = _currentPosition.dy + (distance * sin(_currentTurtleAngle * pi/180));

    final lineToAnimate = TurtleCanvasLine(
      startPoint: Offset(_currentPosition.dx, _currentPosition.dy),
      endPoint: Offset(newX, newY)
    );

    await turtleCanvasController.draw(
      pathToDraw: Path.from(_drawedPath),
      lineToAnimate: lineToAnimate,
      turtleAngle: _currentTurtleAngle,
      turtlePosition: _currentPosition
    );

    _currentPosition = Offset(newX, newY);

    return lineToAnimate;
  }

  Future<void> _rotate(double rotation) async {
    await turtleCanvasController.draw(
      pathToDraw: _drawedPath,
      lineToAnimate: null,
      turtleAngle: _currentTurtleAngle,
      toTurtleAngle: _currentTurtleAngle + rotation,
      turtlePosition: _currentPosition
    );

    _currentTurtleAngle += rotation;
  }

  void _updateDrawedPath(TurtleCanvasLine newLine) {
    _drawedPath.moveTo(newLine.startPoint.dx, newLine.startPoint.dy);
    _drawedPath.lineTo(newLine.endPoint.dx, newLine.endPoint.dy);
  }
}
