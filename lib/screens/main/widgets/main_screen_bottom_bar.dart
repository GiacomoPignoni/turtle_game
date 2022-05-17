import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/extras/extensions.dart';
import 'package:turtle_game/states/canvas_state.dart';
import 'package:turtle_game/widgets/chip_button.dart';
import 'package:turtle_game/widgets/numpad_popup.dart';

class MainScreenBottomBar extends StatelessWidget {
  const MainScreenBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: PlatformExtenstion.isTouchDevice() ? 20 : 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        border: Border(top: BorderSide(color: theme.dividerTheme.color!, width: theme.dividerTheme.thickness!))
      ),
      child: Consumer<CanvasState>(
        builder: (context, canvasState, child) {
          return Row(
            children: [
              NumpadPopupButton(
                disableComma: true,
                builder: (context, showPopup) => GestureDetector(
                  child: Text(
                    "${canvasState.size.width.toInt()}",
                    style: theme.textTheme.bodyText1,
                  ),
                  onTap: () {
                    showPopup(canvasState.size.width).then((newValue){
                      if(newValue != null) {
                        canvasState.changeSize(width: newValue);
                      }
                    });
                  },
                ),
              ),
              Text(
                " x ",
                style: theme.textTheme.bodyText1,
              ),
              NumpadPopupButton(
                disableComma: true,
                builder: (context, showPopup) => GestureDetector(
                  child: Text(
                    "${canvasState.size.height.toInt()}",
                    style: theme.textTheme.bodyText1,
                  ),
                  onTap: () {
                    showPopup(canvasState.size.height).then((newValue){
                      if(newValue != null) {
                        canvasState.changeSize(height: newValue);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 20),
              if(PlatformExtenstion.isTouchDevice() == false)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChipButton(
                    icon: Icons.add_rounded,
                    tooltipText: "Zoom In",
                    onPressed: () => canvasState.zoomIn(),
                  ),
                ),
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
              if(PlatformExtenstion.isTouchDevice() == false)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ChipButton(
                    icon: Icons.remove_rounded,
                    tooltipText: "Zoom Out",
                    onPressed: () => canvasState.zoomOut(),
                  ),
                )
            ],
          );
        }
      ),
    );
  }
}
