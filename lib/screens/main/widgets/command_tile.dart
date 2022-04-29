import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/models/command.dart';
import 'package:turtle_game/screens/main/main_screen_state.dart';
import 'package:turtle_game/widgets/button_icon.dart';
import 'package:turtle_game/widgets/conditional_wrapper.dart';

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
        onTapDelete: () => Provider.of<MainScreenState>(context, listen: false).remove(index),
      )
    );
  }
}

class CommandTileBody extends StatelessWidget {
  final Command command;
  final bool showTrash;
  final Function()? onTapDelete;

  const CommandTileBody({
    Key? key,
    required this.command,
    this.showTrash = false,
    this.onTapDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: command,
      builder: (context, child) {
        return ConditionalWrapper(
          condition: showTrash,
          wrapperBuilder: (context, child) {
            return Stack(
              children: [
                child,
                Positioned(
                  top: 0,
                  right: 0,
                  child: CommandTileBodyDeleteIcon(
                    onPressed: onTapDelete,
                  )
                )
              ],
            );
          },
          child: Container(
            width: 300,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: command.getColor(),
              border: Border.all(color: Theme.of(context).dividerColor, width: Theme.of(context).dividerTheme.thickness!),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    command.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ),
                Expanded(
                  child: Text(
                    command.getValueToShow(),
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

class CommandTileBodyDeleteIcon extends StatefulWidget {
  final Function()? onPressed;

  const CommandTileBodyDeleteIcon({
    required this.onPressed,
    Key? key
  }): super(key: key);

  @override
  State<CommandTileBodyDeleteIcon> createState() => _CommandTileBodyDeleteIconState();
}

class _CommandTileBodyDeleteIconState extends State<CommandTileBodyDeleteIcon> {
  bool _isHover = false;
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => setState(() {_isHover = true;}),
      onExit: (_) => setState(() {_isHover = false;}),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _isDown = true),
        onTapUp: (details) => setState(() => _isDown = false),
        onTapCancel: () => setState(() => _isDown = false),
        child: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: (_isHover) ? Theme.of(context).primaryColorDark.withOpacity(0.8) : Theme.of(context).primaryColorDark,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)
            )
          ),
          child: AnimatedScale(
            scale: _isDown ? 0.9 : 1,
            duration: const Duration(milliseconds: 100),
            child: Icon(
              Icons.close_rounded,
              color: Theme.of(context).primaryColorLight, 
              size: 14
            ),
          ),
        ),
      ),
    );
  }
}
