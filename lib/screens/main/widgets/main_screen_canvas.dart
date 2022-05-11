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
        final canvasState = Provider.of<CanvasState>(context, listen: false);
        if(firstBuild) {
          firstBuild = false;
          canvasState.onFirstBuild(constraints);
        } else {
          canvasState.onConstraintsChanged(constraints);
        }

        return Stack(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          children: [
            Consumer<CanvasState>(
              builder: (context, canvasState, child) {
                return Positioned(
                  left: canvasState.position.dx,
                  top: canvasState.position.dy,
                  height: canvasState.size.height,
                  width: canvasState.size.width,
                  child: AnimatedScale(
                    scale: canvasState.scale,
                    duration: const Duration(milliseconds: 200),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onPanUpdate: (details) => _onPanUpdate(details, canvasState),
                        onDoubleTap: () => canvasState.center(constraints),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: (canvasState.scale != 1 || canvasState.isCentered == false) ? Border.all(color: Theme.of(context).dividerColor, width: 2) : null,
                          ),
                          child: TurtleCanvas(
                            controller: Provider.of<CommandsState>(context, listen: false).turtleCanvasController,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            )
          ],
        );
      }
    );
  }

  _onPanUpdate(DragUpdateDetails details, CanvasState canvasState) {
    canvasState.changePosition(Offset(
      canvasState.position.dx + details.delta.dx, 
      canvasState.position.dy + details.delta.dy, 
    ));
  }
}
