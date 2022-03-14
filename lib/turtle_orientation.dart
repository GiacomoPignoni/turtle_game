import 'package:flutter/cupertino.dart';

class TurtleOrientation extends ChangeNotifier {
  double _angle = 0;

  double get angle => _angle;

  rotate(double rotationValue) {
    _angle += rotationValue;
    notifyListeners();
  }
}