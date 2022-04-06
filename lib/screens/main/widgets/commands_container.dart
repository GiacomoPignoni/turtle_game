import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/screens/main/widgets/command_tile.dart';
import 'package:turtle_game/screens/main/main_screen_state.dart';
import 'package:turtle_game/widgets/resizable_container.dart';

class CommandsContainer extends StatefulWidget {
  const CommandsContainer({Key? key}) : super(key: key);

  @override
  State<CommandsContainer> createState() => _CommandsContainerState();
}

class _CommandsContainerState extends State<CommandsContainer> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {  
        return Consumer<MainScreenState>(
          builder: (context, state, child) {
            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers : [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        sliver: SliverReorderableList(
                          onReorder: state.reorder,
                          itemCount: state.commands.length,
                          itemBuilder: (context, index) => CommandTile(
                            key: ValueKey(index),
                            index: index,
                            command: state.commands[index],
                          ), 
                        ),
                      ),
                    ]
                  )
                ),
                ResizableContainer(
                  initalHeight: 120, 
                  maxHeight: constraints.maxHeight * 0.8, 
                  minHeight: 50,
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
                )
              ],
            );
          }
        );
      }
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
