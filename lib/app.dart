import 'package:flutter/material.dart';
import 'package:turtle_game/routes.dart';
import 'package:turtle_game/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: theme,
      routes: AppRoutes.routesList,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.MAIN_SCREEN,
    );
  }
}
