import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:turtle_game/commands/command_models.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_line.dart';

class CommandsState extends ChangeNotifier {
  final GlobalKey<TurtleCanvasState> turtleCanvasKey = GlobalKey<TurtleCanvasState>();

  final List<Command> commands = [
    Forward(50),
    Rotate(45),
    Forward(50),
    Rotate(45),
    Forward(50)
  ];

  bool _running = false;
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
    if(_running == false) {
      _running = true;
      reset();

      for(final command in commands) { 
        await _execCommand(command);
      }

      _running = false;
    }
  }

  Future<void> onStep() async {
    if(_running == false) {
      _running = true;

      if(_currentCommandIndex == -1) {
        _currentCommandIndex = 0;
      }

      await _execCommand(commands[_currentCommandIndex]);
      _currentCommandIndex++;
      _running = false;
    }
  }

  test() {
    _execCommand(Forward(50));
  }

  testRotate() {
    _execCommand(Rotate(90));
  }

  reset() {
    if(_running == false) {
      _currentCommandIndex = -1;
      _drawedPath = Path();
      _currentTurtleAngle = 0;
      _currentPosition = const Offset(0, 0);
      turtleCanvasKey.currentState?.clear(
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

    await turtleCanvasKey.currentState?.draw(
      pathToDraw: Path.from(_drawedPath),
      lineToAnimate: lineToAnimate,
      turtleAngle: _currentTurtleAngle,
      turtlePosition: _currentPosition
    );

    _currentPosition = Offset(newX, newY);

    return lineToAnimate;
  }

  Future<void> _rotate(double rotation) async {
    await turtleCanvasKey.currentState?.draw(
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
