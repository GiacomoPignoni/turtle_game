import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/models/commands.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas.dart';
import 'package:turtle_game/turtle_canvas/turtle_canvas_controller.dart';
import 'package:turtle_game/turtle_commands.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final commands = [
    Forward(20),
    Rotate(90),
    Forward(20),
    Rotate(90),
    Forward(20),
    Rotate(90),
    Forward(20)
  ];

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return MultiProvider(
      providers: [
        Provider(create: (_) => TurtleCanvasController()),
        Provider(create: (context) => TurtleCommands(Provider.of<TurtleCanvasController>(context)))
      ],
      builder: (context, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TurtleCanvas(
                  controller: Provider.of<TurtleCanvasController>(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<TurtleCanvasController>(context, listen: false).execCommand(commands[i]);
                          i++;
                        }, 
                        child: const Text("Step")
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          for(final command in commands) {
                            await Provider.of<TurtleCanvasController>(context, listen: false).execCommand(command);
                          }
                        }, 
                        child: const Text("Play")
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<TurtleCanvasController>(context, listen: false).reset();
                          i = 0;
                        }, 
                        child: const Text("Reset")
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
