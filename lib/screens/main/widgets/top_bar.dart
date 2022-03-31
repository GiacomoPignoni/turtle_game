import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/screens/main/main_screen_state.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenState>(
      builder: (context, state, child) {
        return Container(
          height: 40,
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TopBarButton(
                icon: Icons.play_arrow_rounded,
                disabled: state.runningState == MainScreenRunningState.running,
                onPressed: state.play,
              ),
              const SizedBox(width: 10),
              TopBarButton(
                icon: Icons.stop_rounded,
                disabled: state.runningState == MainScreenRunningState.stopped,
                onPressed: state.stop,
              ),
              const SizedBox(width: 10),
              TopBarButton(
                icon: Icons.pause_rounded,
                disabled: state.runningState != MainScreenRunningState.running,
                onPressed: state.pause,
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
  final bool disabled;
  final IconData icon;

  const TopBarButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<TopBarButton> createState() => _TopBarButtonState();
}

class _TopBarButtonState extends State<TopBarButton> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: (widget.disabled) ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        onTapDown: widget.disabled ? null : (_) => setState(() => _isDown = true),
        onTapUp: widget.disabled ? null : (details) => setState(() => _isDown = false),
        onTapCancel: widget.disabled ? null : () => setState(() => _isDown = false),
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
    );
  }

  _calculateBackgroundColor() {
    if(widget.disabled) {
      return Colors.transparent;
    } else {
      if(_isDown) {
        return const Color.fromRGBO(0, 0, 0, 0.4);
      } else {
        return const Color.fromRGBO(0, 0, 0, 0.2);
      }
    }
  }
}
