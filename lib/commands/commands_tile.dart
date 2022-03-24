import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/commands/command_models.dart';
import 'package:turtle_game/commands/commands_container.dart';
import 'package:turtle_game/commands/commands_state.dart';

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
      child: DragTarget<CommandDragData>(
        onAccept: (CommandDragData  data) => _onAccept(context, data),
        builder: (context, candidateData, rejectedData) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: (candidateData.isNotEmpty && candidateData.first!.index != index) 
            ? const EdgeInsets.only(bottom: 50)
            : EdgeInsets.zero,
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: command,
            builder: (context, child) => CommandTileBody(
              command: command,
            )
          ),
        )
      ),
    );
  }

  _onAccept(BuildContext context, CommandDragData data) {
    if(data.runtimeType == CommandDragData) {
      Provider.of<CommandsState>(context, listen: false).insert(data.command, index + 1);
    }
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
        return Colors.yellow;
      case Rotate:
        return Colors.blue;
      default: 
        return Colors.white;
    }
  }
}
