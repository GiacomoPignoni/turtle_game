import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/states/commands_state.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CommandsState>(
      builder: (context, state, child) {
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 2))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TopBarButton(
                icon: Icons.play_arrow_rounded,
                disabled: state.runningState == MainScreenRunningState.running,
                onPressed: state.play,
                tooltipText: "Play",
              ),
              const SizedBox(width: 10),
              TopBarButton(
                icon: Icons.stop_rounded,
                disabled: state.runningState == MainScreenRunningState.start || state.runningState == MainScreenRunningState.finished,
                onPressed: state.stop,
                tooltipText: "Stop",
              ),
              const SizedBox(width: 10),
              TopBarButton(
                icon: Icons.pause_rounded,
                disabled: state.runningState != MainScreenRunningState.running,
                onPressed: state.pause,
                tooltipText: "Pause",
              ),
              const SizedBox(width: 10),
              TopBarButton(
                icon: Icons.replay_rounded,
                disabled: state.runningState != MainScreenRunningState.finished,
                onPressed: state.reset,
                tooltipText: "Clear",
              ),
            ],
          ),
        );
      }
    );
  }
}

class TopBarButton extends StatefulWidget {
  final Function() onPressed;
  final IconData icon;
  final String tooltipText;
  final bool disabled;

  const TopBarButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.tooltipText,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<TopBarButton> createState() => _TopBarButtonState();
}

class _TopBarButtonState extends State<TopBarButton> {
  bool _isHover = false;
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: (widget.disabled) ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onHover: (_) => setState(() {
        _isHover = true;
      }),
      onExit: (_) => setState(() {
        _isHover = false;
      }),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        onTapDown: widget.disabled ? null : (_) => setState(() => _isDown = true),
        onTapUp: widget.disabled ? null : (details) => setState(() => _isDown = false),
        onTapCancel: widget.disabled ? null : () => setState(() => _isDown = false),
        child: RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: _calculateBackgroundColor(), 
              borderRadius: BorderRadius.circular(5)
            ),
            child: Icon(
              widget.icon,
              color: (widget.disabled) ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5) : Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  _calculateBackgroundColor() {
    if(widget.disabled) {
      return Colors.transparent;
    }

    if(_isDown) {
      return const Color.fromRGBO(0, 0, 0, 0.4);
    } else if(_isHover) {
      return const Color.fromRGBO(0, 0, 0, 0.2);
    }

    return Colors.transparent;
  }
}