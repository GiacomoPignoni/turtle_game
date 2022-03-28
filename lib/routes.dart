// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:turtle_game/screens/main/main_screen.dart';

class AppRoutes {
  static const MAIN_SCREEN = "main";

  static Map<String, Widget Function(BuildContext)> routesList = {
    MAIN_SCREEN: (_) => const MainScreen()
  };
}
