import 'package:flutter/material.dart';

class CanvasState extends ChangeNotifier {
  Size _size = const Size(0, 0);
  Size get size => _size;

  Offset _position = const Offset(0, 0);
  Offset get position => _position;

  double _scale = 1;
  double get scale => _scale;

  changeSize(double width, double height) {
    _updateSize(width, height);
    notifyListeners();
  }

  changePosition(double x, double y) {
    _updatePosition(x, y);
    notifyListeners();
  }

  changeScale(double newScale) {
    _updateScale(newScale);
    notifyListeners();
  }

  changePositionAndSizeWithoutNotify(double width, double height, double x, double y) {
    _updateSize(width, height);
    _updatePosition(x, y);
  }

  _updateSize(double width, double height) {
    _size = Size(width, height);
    debugPrint("### CANVAS -> NEW POSITION ###");
    debugPrint(_size.toString());
  }

  _updatePosition(double x, double y) {
    _position = Offset(x, y);
    debugPrint("### CANVAS -> NEW POSITION ###");
    debugPrint(_position.toString());
  }

  _updateScale(double newScale) {
    _scale = newScale;
    debugPrint("### CANVAS -> NEW SCALE ###");
    debugPrint(_scale.toString());
  }
}
