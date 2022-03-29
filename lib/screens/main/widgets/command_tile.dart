import 'package:flutter/material.dart';
import 'package:turtle_game/models/command.dart';

class CommandTile extends StatelessWidget {
  final Command command;
  final int index;

  const CommandTile({
    Key? key,
    required this.command,
    required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: CommandTileBody(
        command: command,
      )
    );
  }
}

class CommandTileBody extends StatelessWidget {
  final Command command;

  const CommandTileBody({
    Key? key,
    required this.command
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _getColor(),
      ),
      child: Row(
        children: [
          Text(command.toString()),
          Text(_getValueToShow()),
        ],
      ),
    );
  }

  String _getValueToShow() {
    switch(command.runtimeType) {
      case Forward:
        return (command as Forward).distance.toString();
      case Rotate:
        return (command as Rotate).rotation.toString();
      default: 
        return "";
    }
  }

  Color _getColor() {
    switch(command.runtimeType) {
      case Forward:
        return Forward.color;
      case Rotate:
        return Rotate.color;
      default: 
        return Command.color;
    }
  }
}
