import 'dart:math';
import 'package:flutter/material.dart';

class CanvasState extends ChangeNotifier {
  Size _size = const Size(0, 0);
  Size get size => _size;

  Offset _position = const Offset(0, 0);
  Offset get position => _position;

  double _scale = 1;
  double get scale => _scale;

  bool _isCentered = true;
  bool get isCentered => _isCentered;

  void changeSize({double? width, double? height}) {
    _updateSize(width ?? size.width, height ?? size.height);
    notifyListeners();
  }

  void changePosition(Offset newPosition) {
    _updatePosition(newPosition);
    _isCentered = false;
    notifyListeners();
  }

  void changeScale(double newScale) {
    _updateScale(newScale);
    notifyListeners();
  }

  void onFirstBuild(BoxConstraints constraints) {
    _updateSize(constraints.maxWidth, constraints.maxHeight);
    _updatePosition(Offset.zero);
  }

  void onConstraintsChanged(BoxConstraints constraints) {
    if(_scale == 1 && _isCentered) {
      _updateSize(constraints.maxWidth, constraints.maxHeight);
    }
  }

  void center(BoxConstraints constraints) {
    final centerPosition = _calculateCenterPosition(constraints);
    _isCentered = true;
    _updatePosition(centerPosition);
    notifyListeners();
  }

  void zoomIn() {
    changeScale(_scale + 0.1);
  }

  void zoomOut() {
    changeScale(_scale - 0.1);
  }

  void _updateSize(double width, double height) {
    _size = Size(width, height);
    debugPrint("### CANVAS -> NEW POSITION ###");
    debugPrint(_size.toString());
  }

  void _updatePosition(Offset newPostion) {
    _position = newPostion;
    debugPrint("### CANVAS -> NEW POSITION ###");
    debugPrint(_position.toString());
  }

  void _updateScale(double newScale) {
    // This is a workaround for Stack that it doesn't clip something if the position is exactly 0,0
    if(_position == Offset.zero) {
      _updatePosition(const Offset(0.000000000001, 0.000000000001));
    }

    _scale = max(newScale, 0.1);
    debugPrint("### CANVAS -> NEW SCALE ###");
    debugPrint(_scale.toString());
  }

  Offset _calculateCenterPosition(BoxConstraints constraints) {
    final x = (constraints.maxWidth - _size.width) / 2;
    final y = (constraints.maxHeight - _size.height) / 2;
    return Offset(x, y);
  }
}
