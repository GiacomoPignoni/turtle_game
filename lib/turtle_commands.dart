import 'package:flutter/cupertino.dart';
import 'package:turtle_game/models/commands.dart';

class TurtleCommands extends ChangeNotifier {
  final List<Command> commands = [
    Forward(50),
    Rotate(90),
    Forward(50)
  ];
}
