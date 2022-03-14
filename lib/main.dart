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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => TurtleCanvasController())
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
                          Provider.of<TurtleCanvasController>(context, listen: false).execCommand(Forward(100));
                        }, 
                        child: const Text("Play")
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
