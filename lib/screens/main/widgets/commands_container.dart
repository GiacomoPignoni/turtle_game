import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/models/command.dart';
import 'package:turtle_game/screens/main/widgets/command_tile.dart';
import 'package:turtle_game/screens/main/main_screen_state.dart';

class CommandsContainer extends StatelessWidget {
  const CommandsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenState>(
      builder: (context, state, child) {
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers : [
                  SliverReorderableList(
                    onReorder: state.reorder,
                    itemCount: state.commands.length,
                    itemBuilder: (context, index) => CommandTile(
                      key: ValueKey(index),
                      index: index,
                      command: state.commands[index],
                    ), 
                  ),
                ]
              )
            ),
            const Divider(height: 1, color: Colors.black, thickness: 1),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  state.selectableCommands.length, 
                  (index) {
                    final command = state.selectableCommands[index];
    
                    return GestureDetector(
                      onTap: () => Provider.of<MainScreenState>(context, listen: false).insert(command),
                      child: CommandTileBody(
                        command: command,
                      ),
                    );
                  }
                ),
              ),
            )
          ],
        );
      }
    );
  }
}

class CommandDragData {
  final Command command;
  final int? index;

  CommandDragData(this.command, this.index);
}
