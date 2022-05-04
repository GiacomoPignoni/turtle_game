import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/states/commands_state.dart';
import 'package:turtle_game/states/canvas_state.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas.dart';


class MainScreenCanvas extends StatelessWidget {
  const MainScreenCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool firstBuild = true;

    return LayoutBuilder(
      builder: (context, constraints) {
        if(firstBuild) {
          firstBuild = false;
          final canvasState = Provider.of<CanvasState>(context, listen: false);
          canvasState.changePositionAndSizeWithoutNotify(
            constraints.maxWidth, 
            constraints.maxHeight,
            0, 
            0
          );
        }

        return Consumer<CanvasState>(
          builder: (context, canvasState, child) {
            return Stack(
              children: [
                Positioned(
                  left: canvasState.position.dx,
                  top: canvasState.position.dy,
                  height: canvasState.size.height,
                  width: canvasState.size.width,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onPanUpdate: (details) => _onPanUpdate(details, canvasState),
                      child: TurtleCanvas(
                        controller: Provider.of<CommandsState>(context, listen: false).turtleCanvasController,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        );
      }
    );
  }

  _onPanUpdate(DragUpdateDetails details, CanvasState canvasState) {
    canvasState.changePosition(
      canvasState.position.dx + details.delta.dx, 
      canvasState.position.dy + details.delta.dy, 
    );
  }
}
