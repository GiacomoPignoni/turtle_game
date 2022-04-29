import 'package:flutter/material.dart';
import 'package:turtle_game/extras/extensions.dart';
class Command extends ChangeNotifier {
  static const Color color = Colors.white;

  double get value => double.nan;

  Command();

  Command copy() {
    return Command();
  }

  Color getColor() {
    return color;
  }

  String getValueToShow() {
    return "";
  }

  void changeValue(dynamic newValue) => {};
}

class Forward extends Command {
  static const Color color = Color(0xFFE57373);

  int distance;

  @override
  double get value => distance.toDouble();

  Forward(this.distance);

  @override
  Forward copy() {
    return Forward(distance);
  }

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

  @override
  void changeValue(dynamic newValue) {
    if(newValue.runtimeType == double) {
      distance = (newValue as double).toInt();
      notifyListeners();
    }
  }
}

class Rotate extends Command {
  static const Color color = Color(0xFF81C784);

  double rotation;

  @override
  double get value => rotation;

  Rotate(this.rotation);

  @override
  Rotate copy() {
    return Rotate(rotation);
  }

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
    return rotation.toStringWihtoutTrailingZeros();
  }

  @override
  void changeValue(dynamic newValue) {
    if(newValue.runtimeType == double) {
      rotation = newValue;
      notifyListeners();
    }
  }
}
