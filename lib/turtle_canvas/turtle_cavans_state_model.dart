import 'dart:ui';

import 'package:turtle_game/models/pair.dart';

class TurtleCavnasStateModel {
  final List<Pair<Offset, Offset>> linesToDraw;
  final Path? toAnimatePath;
  double turtleAngle;
  final double toTurtleAngle;

  TurtleCavnasStateModel({
    required this.linesToDraw,
    required this.toAnimatePath,
    required this.turtleAngle,
    required this.toTurtleAngle
  });

  TurtleCavnasStateModel copyWith({
    List<Pair<Offset, Offset>>? linesToDraw,
    Path? toAnimatePath,
    double? turtleAngle,
    double? toTurtleAngle 
  }) {
    return TurtleCavnasStateModel(
      linesToDraw: linesToDraw ?? this.linesToDraw,
      toAnimatePath: toAnimatePath,
      turtleAngle: turtleAngle ?? this.turtleAngle,
      toTurtleAngle: toTurtleAngle ?? this.toTurtleAngle
    );
  }
}
