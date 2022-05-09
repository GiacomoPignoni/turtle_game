import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/states/commands_state.dart';
import 'package:turtle_game/widgets/chip_button.dart';

class MainScreenTopBar extends StatelessWidget {
  const MainScreenTopBar({Key? key}) : super(key: key);

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
              ChipButton(
                icon: Icons.play_arrow_rounded,
                disabled: state.runningState == MainScreenRunningState.running,
                onPressed: state.play,
                tooltipText: "Play",
              ),
              const SizedBox(width: 10),
              ChipButton(
                icon: Icons.stop_rounded,
                disabled: state.runningState == MainScreenRunningState.start || state.runningState == MainScreenRunningState.finished,
                onPressed: state.stop,
                tooltipText: "Stop",
              ),
              const SizedBox(width: 10),
              ChipButton(
                icon: Icons.pause_rounded,
                disabled: state.runningState != MainScreenRunningState.running,
                onPressed: state.pause,
                tooltipText: "Pause",
              ),
              const SizedBox(width: 10),
              ChipButton(
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
