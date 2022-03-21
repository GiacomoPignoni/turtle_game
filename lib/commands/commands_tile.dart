import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/commands/command_models.dart';
import 'package:turtle_game/commands/commands_state.dart';

class CommandTileDragData {
  final Command command;
  final int? index;

  CommandTileDragData(this.command, this.index);
}

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
    return Draggable(
      feedback: CommandTileFeedback(command: command),
      data: CommandTileDragData(command, index),
      child: DragTarget<CommandTileDragData>(
        onAccept: (CommandTileDragData  data) => _onAccept(context, data),
        builder: (context, candidateData, rejectedData) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: (candidateData.isNotEmpty && candidateData.first!.index != index) 
            ? const EdgeInsets.only(bottom: 50)
            : EdgeInsets.zero,
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: command,
            builder: (context, child) => CommandTileBody(
              name: command.toString(),
            )
          ),
        )
      ),
    );
  }

  _onAccept(BuildContext context, CommandTileDragData data) {
    if(data.runtimeType == CommandTileDragData) {
      if(data.index != null) {
        Provider.of<CommandsState>(context, listen: false).reorder(data.index!, index + 1);
      } else {
        Provider.of<CommandsState>(context, listen: false).insert(data.command, index + 1);
      }
    }
  }
}

class CommandTileBody extends StatelessWidget {
  final String name;
  final String? value;

  const CommandTileBody({
    Key? key,
    required this.name,
    this.value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.red,
      ),
      child: Row(
        children: [
          Text(name),
          value != null ? Text(value!) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class CommandTileFeedback extends StatelessWidget {
  final Command command;

  const CommandTileFeedback({
    Key? key,
    required this.command
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommandTileBody(
      name: command.toString(),
    );
  }
}
