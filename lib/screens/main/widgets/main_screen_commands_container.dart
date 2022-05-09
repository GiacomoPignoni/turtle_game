import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/screens/main/widgets/main_screen_command_tile.dart';
import 'package:turtle_game/states/commands_state.dart';
import 'package:turtle_game/widgets/resizable_container.dart';

class MainScreenCommandsContainer extends StatefulWidget {
  const MainScreenCommandsContainer({Key? key}) : super(key: key);

  @override
  State<MainScreenCommandsContainer> createState() => _MainScreenCommandsContainerState();
}

class _MainScreenCommandsContainerState extends State<MainScreenCommandsContainer> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {  
        return Consumer<CommandsState>(
          builder: (context, state, child) {
            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers : [
                      SliverPadding(
                        padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 5),
                        sliver: SliverReorderableList(
                          onReorder: state.reorder,
                          itemCount: state.commands.length,
                          itemBuilder: (context, index) => Padding(
                            key: ValueKey(state.commands[index].hashCode),
                            padding: const EdgeInsets.only(bottom: 5),
                            child: MainScreenCommandTile(
                              index: index,
                              command: state.commands[index],
                            ),
                          ), 
                        ),
                      ),
                    ]
                  )
                ),
                ResizableContainer(
                  initialHeight: 135, 
                  maxHeight: constraints.maxHeight * 0.8, 
                  minHeight: 50,
                  toggleColor: Theme.of(context).dividerColor,
                  child: ListView(
                    padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                    children: List.generate(
                      state.selectableCommands.length, 
                      (index) {
                        final command = state.selectableCommands[index];
                    
                        return GestureDetector(
                          onTap: () => Provider.of<CommandsState>(context, listen: false).insert(command),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CommandTileBody(
                              command: command,
                            ),
                          ),
                        );
                      },
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
