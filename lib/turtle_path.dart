import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:turtle_game/turtle_orientation.dart';

class TurtlePath extends ChangeNotifier {
  final TurtleOrientation _turtleOrientation;

  Path toDrawPath = Path();
  Path? toAnimatePath;

  TurtlePath(this._turtleOrientation) {
    print("WE");
  }

  reset() {
    toDrawPath = Path();
    toAnimatePath = null;
    notifyListeners();
  }

  forward(int distance) {
    if(toAnimatePath != null) {
      toDrawPath = Path.combine(PathOperation.union, toDrawPath, toAnimatePath!);
    }

    final path = Path();
    final x = 0 + (distance * cos(_turtleOrientation.angle * pi/180));
    final y = 0 + (distance * sin(_turtleOrientation.angle * pi/180));
    path.lineTo(x, y);
    toAnimatePath = path;

    notifyListeners();
  }
}