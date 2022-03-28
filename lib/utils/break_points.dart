// ignore_for_file: constant_identifier_names

class BreakPoints {
  static const MIN_HORIZONTAL_WIDTH = 500;

  static bool isHorizontal(double screenMaxWidth) {
    return screenMaxWidth > MIN_HORIZONTAL_WIDTH;
  }
}
