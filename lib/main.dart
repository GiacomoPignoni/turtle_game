import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/commands/commands_container.dart';
import 'package:turtle_game/commands/commands_state.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CommandsState())
      ],
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isHorizontal = constraints.maxWidth > 500;

                return Flex(
                  direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: isHorizontal ? 2 : 1,
                      child: TurtleCanvas(
                        key: Provider.of<CommandsState>(context, listen: false).turtleCanvasKey,
                      ),
                    ),
                    isHorizontal 
                      ? const VerticalDivider(width: 1, color: Colors.black, thickness: 1)
                      : const Divider(height: 1, color: Colors.black, thickness: 1),
                    Flexible(
                      child: ConstrainedBox(
                        constraints: isHorizontal ? const BoxConstraints(maxWidth: 300) : const BoxConstraints(),
                        child: const CommandsContainer()
                      ),
                    )
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
