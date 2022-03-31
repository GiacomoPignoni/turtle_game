import 'package:flutter/material.dart';

class Command {
  static const Color color = Colors.white;

  const Command();

  Color getColor() {
    return color;
  }

  String getValueToShow() {
    return "";
  }
}

class Forward extends Command {
  static const Color color = Colors.blue;

  final int distance;

  const Forward(this.distance);

  @override
  String toString() {
    return "Forward";
  }

  @override
  Color getColor() {
    return color;
  }

  @override
  String getValueToShow() {
    return distance.toString();
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

  @override
  Color getColor() {
    return color;
  }

  @override
  String getValueToShow() {
    return rotation.toString();
  }
}
