import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () => Provider.of<TurtleCommands>(context, listen: false).play(), 
                        child: const Text("Play")
                      ),
                      ElevatedButton(
                        onPressed: () => Provider.of<TurtleCommands>(context, listen: false).reset(), 
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
