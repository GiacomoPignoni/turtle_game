import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/screens/main/widgets/commands_container.dart';
import 'package:turtle_game/screens/main/main_screen_state.dart';
import 'package:turtle_game/screens/main/widgets/top_bar.dart';
import 'package:turtle_game/utils/break_points.dart';
import 'package:turtle_game/widgets/conditional_wrapper.dart';
import 'package:turtle_game/widgets/turtle_canvas/turtle_canvas.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainScreenState>(
      create: (_) => MainScreenState(),
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isHorizontal = BreakPoints.isHorizontal(constraints.maxWidth);
          
                return Column(
                  children: [
                    const TopBar(),
                    Expanded(
                      child: Flex(
                        direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: isHorizontal ? 2 : 1,
                            child: TurtleCanvas(
                              controller: Provider.of<MainScreenState>(context, listen: false).turtleCanvasController,
                              alignment: Alignment.center,
                            ),
                          ),
                          if (isHorizontal) 
                            const VerticalDivider(width: 1, color: Colors.black, thickness: 1)
                          else 
                            const Divider(height: 1, color: Colors.black, thickness: 1),
                          ConditionalWrapper(
                            condition: isHorizontal == false,
                            wrapperBuilder: (context, child) => Flexible(child: child),
                            child: ConstrainedBox(
                              constraints: isHorizontal ? const BoxConstraints(maxWidth: 300, minWidth: 300) : const BoxConstraints(),
                              child: const CommandsContainer()
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          ),
        );
      }
    );
  }
}
