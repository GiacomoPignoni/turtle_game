import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/models/command.dart';
import 'package:turtle_game/screens/main/main_screen_state.dart';
import 'package:turtle_game/widgets/button_icon.dart';
import 'package:turtle_game/widgets/numpad_popup.dart';

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
      child: CommandTileBody(
        command: command,
        showTrash: true,
        onTapTrash: () => Provider.of<MainScreenState>(context, listen: false).remove(index),
      )
    );
  }
}

class CommandTileBody extends StatelessWidget {
  final Command command;
  final bool showTrash;
  final Function()? onTapTrash;

  const CommandTileBody({
    Key? key,
    required this.command,
    this.showTrash = false,
    this.onTapTrash
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: command,
      builder: (context, child) {
        return Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: command.getColor(),
          ),
          child: Row(
            children: [
              Text(command.toString()),
              Text(command.getValueToShow()),
              if(showTrash) ButtonIcon(
                icon: const Icon(
                  Icons.delete
                ), 
                onPressed: () => onTapTrash?.call()
              ),
              NumpadPopupButton(
                builder: (context, showPopup) {
                  return ElevatedButton(
                    child: const Text("Ciao ciao"),
                    onPressed: () async {
                      final result = await showPopup(command.value);
                      command.changeValue(result);
                    }
                  );
                },
              )
            ],
          ),
        );
      }
    );
  }
}
