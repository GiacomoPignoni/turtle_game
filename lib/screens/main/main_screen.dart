import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/screens/main/widgets/main_screen_bottom_bar.dart';
import 'package:turtle_game/screens/main/widgets/main_screen_canvas.dart';
import 'package:turtle_game/screens/main/widgets/main_screen_commands_container.dart';
import 'package:turtle_game/states/commands_state.dart';
import 'package:turtle_game/screens/main/widgets/main_screen_top_bar.dart';
import 'package:turtle_game/extras/screen_utils.dart';
import 'package:turtle_game/states/canvas_state.dart';
import 'package:turtle_game/widgets/conditional_wrapper.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommandsState()),
        ChangeNotifierProvider(create: (_) => CanvasState())
      ],
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isHorizontal = ScreenUtils.isHorizontal(constraints.maxWidth);
              
                return Column(
                  children: [
                    const MainScreenTopBar(),
                    Expanded(
                      child: Flex(
                        direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: isHorizontal ? 2 : 1,
                            child: const MainScreenCanvas()
                          ),
                          if (isHorizontal) 
                            const VerticalDivider(width: 2, thickness: 2)
                          else 
                            const Divider(height: 2, thickness: 2),
                          ConditionalWrapper(
                            condition: isHorizontal == false,
                            wrapperBuilder: (context, child) => Flexible(child: child),
                            child: ConstrainedBox(
                              constraints: isHorizontal ? const BoxConstraints(maxWidth: 300, minWidth: 300) : const BoxConstraints(),
                              child: const MainScreenCommandsContainer()
                            ),
                          ),
                        ],
                      ),
                    ),
                    const MainScreenBottomBar()
                  ],
                );
              },
            )
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.smartphone_rounded),
            onPressed: () {
              ScreenUtils.toggleSmartphoneView();
            },
          ),
        );
      }
    );
  }
}
