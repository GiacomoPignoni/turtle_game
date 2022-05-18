import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/extras/extensions.dart';
import 'package:turtle_game/states/canvas_state.dart';
import 'package:turtle_game/widgets/button_icon.dart';
import 'package:turtle_game/widgets/numpad_popup.dart';

class MainScreenBottomBar extends StatelessWidget {
  const MainScreenBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        border: Border(top: BorderSide(color: theme.dividerTheme.color!, width: theme.dividerTheme.thickness!))
      ),
      child: Consumer<CanvasState>(
        builder: (context, canvasState, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(PlatformExtenstion.isTouchDevice() == false)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ButtonIcon(
                     icon: Icon(
                      Icons.zoom_out,
                      color: theme.colorScheme.onPrimary,
                    ),
                    onPressed: () => canvasState.zoomOut(),
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
                  child: ButtonIcon(
                    icon: Icon(
                      Icons.zoom_in,
                      color: theme.colorScheme.onPrimary,
                    ),
                    onPressed: () => canvasState.zoomIn(),
                  ),
                )
            ],
          );
        }
      ),
    );
  }
}
