import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:turtle_game/models/command.dart';
import 'package:turtle_game/extras/points_utils.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas_controller.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas_line.dart';
import 'dart:async';

enum MainScreenRunningState {
  start,
  running,
  paused,
  finished
}

class CommandsState extends ChangeNotifier {
  final TurtleCanvasController turtleCanvasController = TurtleCanvasController();

  final selectableCommands = [
    Forward(50),
    Rotate(90)
  ];

  final List<Command> commands = [
    Forward(50),
    Rotate(45),
    Forward(50),
    Rotate(45),
    Forward(50)
  ];

  MainScreenRunningState runningState = MainScreenRunningState.start;

  Path _drawedPath = Path();
  double _currentTurtleAngle = 0;
  Offset _currentPosition = const Offset(0, 0);
  int _currentCommandIndex = -1;
  CancelableOperation<void>? _commandCancellableOperation;

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Command command = commands.removeAt(oldIndex);
    commands.insert(newIndex, command);
    notifyListeners();
  }

  void insert(Command command, {int? index}) {
    commands.insert(index ?? commands.length, command.copy());
    notifyListeners();
  }

  void remove(int index) {
    commands.removeAt(index);
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

      _currentCommandIndex++;
      for(int i = _currentCommandIndex; i < commands.length; i++) { 
        if(runningState != MainScreenRunningState.running) break;
        _currentCommandIndex = i;
        _commandCancellableOperation = CancelableOperation.fromFuture(_execCommand(commands[i]));
        await _commandCancellableOperation!.value;  
      }

      runningState = MainScreenRunningState.finished;
      notifyListeners();
    }
  }

  void pause() {
    if(runningState == MainScreenRunningState.running) {
      turtleCanvasController.pauseAnimation();
      _commandCancellableOperation?.cancel();
      runningState = MainScreenRunningState.paused;
      notifyListeners();
    }
  }

  void stop() {
    if(runningState != MainScreenRunningState.start) {
      _reset();
      _commandCancellableOperation?.cancel();
      runningState = MainScreenRunningState.start;
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
      runningState = MainScreenRunningState.paused;
    }
  }

  void reset() {
    _reset();
    runningState = MainScreenRunningState.start;
    notifyListeners();
  }

  void _reset() {
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
