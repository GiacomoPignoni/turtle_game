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
  final ValueNotifier<double> _selectableCommandsHeight = ValueNotifier(120);
  final ScrollController _scrollController = ScrollController();

  double _startDragY = 0;
  double _maxSelectableCommandsHeight = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _calculateMaxSelectableCommandsHeight(constraints);
  
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
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.resizeUpDown,
                    child: Divider(height: 4, color: Colors.black, thickness: 1)
                  )
                ),
                ValueListenableBuilder<double>(
                  valueListenable: _selectableCommandsHeight,
                  builder: (context, selectableCommandsHeight, child) {
                    return SizedBox(
                      height: selectableCommandsHeight,
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
                    );
                  }
                )
              ],
            );
          }
        );
      }
    );
  }

  _calculateMaxSelectableCommandsHeight(BoxConstraints constraints) {
    _maxSelectableCommandsHeight = constraints.maxHeight * 0.8;
    if(_selectableCommandsHeight.value > _maxSelectableCommandsHeight) {
      _selectableCommandsHeight.value = _maxSelectableCommandsHeight;
    }
  }

  _onPanStart(DragStartDetails details) {
    _startDragY = details.globalPosition.dy;
  }

  _onPanUpdate(DragUpdateDetails details) {
    final newValue = _selectableCommandsHeight.value - (details.globalPosition.dy - _startDragY);

    if(newValue < 1) {
      _selectableCommandsHeight.value = 1;
    } else if(newValue > _maxSelectableCommandsHeight) {
      _selectableCommandsHeight.value = _maxSelectableCommandsHeight;
    } else {
      _selectableCommandsHeight.value = newValue;
    }

    _startDragY = details.globalPosition.dy; 
  }

  @override
  void dispose() {
    _selectableCommandsHeight.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
