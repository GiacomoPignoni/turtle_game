
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:turtle_game/models/commands.dart';
import 'package:turtle_game/turtle_orientation.dart';
import 'package:turtle_game/turtle_path.dart';

class TurtleCommands extends ChangeNotifier {
  final TurtlePath _turtlePath;
  final TurtleOrientation _turtleOrientation;

  final List<Command> commands = [
    Forward(50),
    Rotate(90),
    Forward(50)
  ];

  TurtleCommands(
    this._turtlePath,
    this._turtleOrientation
  );

  play() async {
    for(final command in commands) {
      switch(command.runtimeType) {
        case Forward:
          _turtlePath.forward((command as Forward).value);
          break;
        case Rotate:
          _turtleOrientation.rotate((command as Rotate).rotationValue);
          break;
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }
}