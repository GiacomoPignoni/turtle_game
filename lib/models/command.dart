import 'package:flutter/material.dart';

class Command {
  static const Color color = Colors.white;

  double get value => double.nan;

  const Command();

  Color getColor() {
    return color;
  }

  String getValueToShow() {
    return "";
  }
}

class Forward extends Command {
  static const Color color = Color(0xFFE57373);

  final int distance;

  @override
  double get value => distance.toDouble();

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
  static const Color color = Color(0xFF81C784);

  final double rotation;

  @override
  double get value => rotation;

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
