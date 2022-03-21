import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/commands/commands_tile.dart';
import 'package:turtle_game/commands/commands_state.dart';

class CommandsContainer extends StatelessWidget {
  const CommandsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CommandsState>(
      builder: (context, commandsState, child) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          itemCount: commandsState.commands.length,
          itemBuilder: (context, index) => CommandTile(
            index: index,
            command: commandsState.commands[index],
          ),
          separatorBuilder: (context, index) => const Divider(color: Colors.transparent,),
        );
      }
    );
  }
}
