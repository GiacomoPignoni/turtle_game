import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:turtle_game/models/command.dart';
import 'package:turtle_game/utils/points_utils.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas_controller.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas_line.dart';
import 'dart:async';

enum MainScreenRunningState {
  stopped,
  running,
  paused,
  finished
}

class MainScreenState extends ChangeNotifier {
  final TurtleCanvasController turtleCanvasController = TurtleCanvasController();

  final selectableCommands = const [
    Forward(50),
    Rotate(90)
  ];

  final List<Command> commands = [
    const Forward(50),
    const Rotate(45),
    const Forward(50),
    const Rotate(45),
    const Forward(50)
  ];

  MainScreenRunningState runningState = MainScreenRunningState.stopped;

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

  insert(Command command, {int? index}) {
    commands.insert(index ?? commands.length, command);
    notifyListeners();
  }

  Future<void> play() async {
    if(runningState != MainScreenRunningState.running) {
      final lastRunningState = runningState;
      runningState = MainScreenRunningState.running;
      notifyListeners();

      if(lastRunningState == MainScreenRunningState.paused) {
        await turtleCanvasController.playAnimation();
      } else {
        _reset();
      }      

      for(final command in commands) { 
        if(runningState != MainScreenRunningState.running) return;
        await _execCommand(command);
      }

      runningState = MainScreenRunningState.finished;
      notifyListeners();
    }
  }

  pause() {
    if(runningState == MainScreenRunningState.running) {
      turtleCanvasController.pauseAnimation();
      runningState = MainScreenRunningState.paused;
      notifyListeners();
    }
  }

  stop() {
    if(runningState != MainScreenRunningState.stopped) {
      _reset();
      runningState = MainScreenRunningState.stopped;
      notifyListeners();
    }
  }

  Future<void> oneStep() async {
    if(runningState != MainScreenRunningState.running) {
      runningState = MainScreenRunningState.running;

      if(_currentCommandIndex == -1) {
        _currentCommandIndex = 0;
        notifyListeners();
      }

      await _execCommand(commands[_currentCommandIndex]);
      _currentCommandIndex++;
      runningState = MainScreenRunningState.stopped;
    }
  }

  _reset() {
    _currentCommandIndex = -1;
    _drawedPath = Path();
    _currentTurtleAngle = 0;
    _currentPosition = const Offset(0, 0);
    turtleCanvasController.clear(
      turtleAngle: _currentTurtleAngle,
      turtlePosition: _currentPosition
    );
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
    final newPoint = PointsUtils.newPointFromDistance(_currentPosition, _currentTurtleAngle, distance.toDouble());
    final lineToAnimate = TurtleCanvasLine(
      startPoint: Offset(_currentPosition.dx, _currentPosition.dy),
      endPoint: newPoint
    );

    await turtleCanvasController.draw(
      pathToDraw: Path.from(_drawedPath),
      lineToAnimate: lineToAnimate,
      turtleAngle: _currentTurtleAngle,
      turtlePosition: _currentPosition
    );

    _currentPosition = newPoint;

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

  @override
  void dispose() {
    turtleCanvasController.dispose();
    super.dispose();
  }
}
