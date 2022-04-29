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
                        padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 5),
                        sliver: SliverReorderableList(
                          onReorder: state.reorder,
                          itemCount: state.commands.length,
                          itemBuilder: (context, index) => Padding(
                            key: ValueKey(state.commands[index].hashCode),
                            padding: const EdgeInsets.only(bottom: 5),
                            child: CommandTile(
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
                  initalHeight: 120, 
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
                          onTap: () => Provider.of<MainScreenState>(context, listen: false).insert(command),
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
