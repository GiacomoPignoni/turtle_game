import 'package:flutter/material.dart';

class Command {
  static const Color color = Colors.white;

  const Command();
}

class Forward extends Command {
  static const Color color = Colors.blue;

  final int distance;

  const Forward(this.distance);

  @override
  String toString() {
    return "Forward";
  }
}

class Rotate extends Command {
  static const Color color = Colors.yellow;

  final double rotation;

  const Rotate(this.rotation);

  @override
  String toString() {
    return "Rotate";
  }
}
