import 'dart:io';

import 'package:flutter/material.dart';
import 'package:turtle_game/app.dart';
import 'package:turtle_game/extras/screen_utils.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupWindow();

  runApp(const MyApp());
}

Future<void> setupWindow() async {
  if(Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    await windowManager.ensureInitialized();
  
    WindowOptions windowOptions = WindowOptions(
      minimumSize: const Size(ScreenUtils.MIN_HORIZONTAL_WIDTH + 20, ScreenUtils.MIN_HORIZONTAL_HEIGHT),
      center: true,
    );
  
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
