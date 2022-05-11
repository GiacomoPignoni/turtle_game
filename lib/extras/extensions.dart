import 'dart:io';

extension DoubleExtension on double {
  String toStringWihtoutTrailingZeros() {
    return toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }
}

extension PlatformExtenstion on Platform {
  static bool isTouchDevice() {
    return Platform.isIOS || Platform.isAndroid;
  }
}
