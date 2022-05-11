import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/states/canvas_state.dart';
import 'package:turtle_game/widgets/chip_button.dart';
import 'package:turtle_game/widgets/numpad_popup.dart';

class MainScreenBottomBar extends StatelessWidget {
  const MainScreenBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 2))
      ),
      child: Consumer<CanvasState>(
        builder: (context, canvasState, child) {
          return Row(
            children: [
              ChipButton(
                icon: Icons.add_rounded,
                tooltipText: "Zoom In",
                onPressed: () => canvasState.zoomIn(),
              ),
              const SizedBox(width: 10),
              NumpadPopupButton(
                disableComma: true,
                builder: (context, showPopup) => GestureDetector(
                  child: Text(
                    "${(canvasState.scale * 100).toStringAsFixed(0)}%",
                    style: theme.textTheme.bodyText1,
                  ),
                  onTap: () {
                    showPopup((canvasState.scale * 100).roundToDouble()).then((newValue){
                      if(newValue != null) {
                        canvasState.changeScale(newValue / 100);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              ChipButton(
                icon: Icons.remove_rounded,
                tooltipText: "Zoom Out",
                onPressed: () => canvasState.zoomOut(),
              )
            ],
          );
        }
      ),
    );
  }
}
