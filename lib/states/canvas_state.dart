import 'dart:math';
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

  center(BoxConstraints constraints) {
    final x = (constraints.maxWidth - _size.width) / 2;
    final y = (constraints.maxHeight - _size.height) / 2;
    changePosition(x, y);
  }

  zoomIn() {
    changeScale(_scale + 0.1);
  }

  zoomOut() {
    changeScale(min(_scale - 0.1, 0));
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
