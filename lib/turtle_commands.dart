import 'package:flutter/cupertino.dart';
import 'package:turtle_game/models/commands.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_controller.dart';

class TurtleCommands extends ChangeNotifier {
  final TurtleCanvasController _turtleCanvasController;

  final List<Command> commands = [
    Forward(50),
    Rotate(90),
    Forward(50)
  ];

  bool _running = false;

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

  _forward(int distance) {
    
  }

  _rotate(double rotation) {
    
  }
}
