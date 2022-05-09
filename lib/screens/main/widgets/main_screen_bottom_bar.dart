import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/states/canvas_state.dart';
import 'package:turtle_game/widgets/chip_button.dart';

class MainScreenBottomBar extends StatelessWidget {
  const MainScreenBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 2))
      ),
      child: Row(
        children: [
          ChipButton(
            icon: Icons.add_rounded,
            tooltipText: "Zoom In",
            onPressed: () => Provider.of<CanvasState>(context, listen: false).zoomIn(),
          ),
          ChipButton(
            icon: Icons.remove_rounded,
            tooltipText: "Zoom Out",
            onPressed: () => Provider.of<CanvasState>(context, listen: false).zoomOut(),
          )
        ],
      ),
    );
  }
}
