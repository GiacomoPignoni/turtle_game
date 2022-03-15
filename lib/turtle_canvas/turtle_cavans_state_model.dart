import 'dart:ui';

class TurtleCavnasStateModel {
  final Path staticPath;
  final Path? toDrawPath;
  double turtleOrientation;
  final double toTurtleOrientation;

  TurtleCavnasStateModel({
    required this.staticPath,
    required this.toDrawPath,
    required this.turtleOrientation,
    required this.toTurtleOrientation
  });

  TurtleCavnasStateModel copyWith({
    Path? staticPath,
    Path? toDrawPath,
    double? turtleOrientation,
    double? toTurtleOrientation 
  }) {
    return TurtleCavnasStateModel(
      staticPath: staticPath ?? this.staticPath,
      toDrawPath: toDrawPath,
      turtleOrientation: turtleOrientation ?? this.turtleOrientation,
      toTurtleOrientation: toTurtleOrientation ?? this.toTurtleOrientation
    );
  }
}
