import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/commands/command_models.dart';
import 'package:turtle_game/commands/commands_state.dart';
import 'package:turtle_game/commands/commands_tile.dart';

class CommandsContainer extends StatelessWidget {
  static final selectableCommands = [
    Forward(50),
    Rotate(90)
  ];

  const CommandsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<CommandsState>(
            builder: (context, commandsState, child) {
              return CustomScrollView(
                slivers : [
                  SliverReorderableList(
                    onReorder: commandsState.reorder,
                    itemCount: commandsState.commands.length,
                    itemBuilder: (context, index) => CommandTile(
                      key: ValueKey(index),
                      index: index,
                      command: commandsState.commands[index],
                    ), 
                  ),
                ]
              );
            }
          ),
        ),
        const Divider(height: 1, color: Colors.black, thickness: 1),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              selectableCommands.length, 
              (index) {
                final command = selectableCommands[index];

                return Draggable(
                  data: CommandDragData(command, null),
                  feedback: Material(
                    child: CommandTileBody(
                      command: command,
                    ),
                  ),
                  child: CommandTileBody(
                    command: command
                  ), 
                );
              }
            ),
          ),
        )
      ],
    );
  }
}

class CommandDragData {
  final Command command;
  final int? index;

  CommandDragData(this.command, this.index);
}
