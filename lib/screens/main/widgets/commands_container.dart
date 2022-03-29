import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/screens/main/widgets/command_tile.dart';
import 'package:turtle_game/screens/main/main_screen_state.dart';

class CommandsContainer extends StatefulWidget {
  const CommandsContainer({Key? key}) : super(key: key);

  @override
  State<CommandsContainer> createState() => _CommandsContainerState();
}

class _CommandsContainerState extends State<CommandsContainer> {
  double _selectableCommandsHeight = 120;
  double _startDragY = 0;

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
            MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: GestureDetector(
                onPanStart: ((details) => _startDragY = details.globalPosition.dy),
                onPanUpdate: ((details) => setState(() {
                  _selectableCommandsHeight -= details.globalPosition.dy - _startDragY;
                  _startDragY = details.globalPosition.dy;
                  
                })),
                child: const Divider(height: 4, color: Colors.black, thickness: 1)
              ),
            ),
            (_selectableCommandsHeight > 0) ? SizedBox(
              height: _selectableCommandsHeight,
              width: double.infinity,
              child: ListView(
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
            ) : const SizedBox.shrink()
          ],
        );
      }
    );
  }
}
