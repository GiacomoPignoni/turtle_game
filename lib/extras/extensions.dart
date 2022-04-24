extension DoubleExtension on double {
  String toStringWihtoutTrailingZeros() {
    return toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }
}
