import 'package:flutter/cupertino.dart';

class Command extends ChangeNotifier {
  bool _active = false;

  bool get active => _active;

  set active(bool newValue) {
    _active = newValue;
    notifyListeners();
  }
}

class Forward extends Command {
  int distance;

  Forward(this.distance);

  @override
  String toString() {
    return "Forward";
  }
}

class Rotate extends Command {
  double rotation;

  Rotate(this.rotation);

  @override
  String toString() {
    return "Rotate";
  }
}
