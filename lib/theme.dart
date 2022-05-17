import 'package:flutter/material.dart';

const Color eeireBlack = Color(0xFF252627);
const Color lightGray = Color(0xFFD3D4D9);
const Color gray = Color(0xFFC2D3CD);
const Color snow = Color(0xFFFFF9FB);
const Color fireBrick = Color(0xFFBB0A21);
const Color blueMunsell = Color(0xFF4B88A2);
const Color fernGreen = Color(0xFF4B7F52);

final theme = ThemeData(
  brightness: Brightness.light,
  fontFamily: "Poppins",
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: snow,
      fontSize: 14,
      fontWeight: FontWeight.normal
    ),
    bodyText2: TextStyle(
      color: eeireBlack,
      fontSize: 14,
      fontWeight: FontWeight.normal
    )
  ),
  backgroundColor: snow,
  scaffoldBackgroundColor: snow,
  primaryColorLight: snow,
  primaryColorDark: eeireBlack,
  shadowColor: gray,
  dividerTheme: const DividerThemeData(
    color: eeireBlack,
    thickness: 1,
    space: 1
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: blueMunsell,
    onPrimary: snow,
    secondary: fernGreen,
    onSecondary: snow,
    error: fireBrick,
    onError: snow,
    background: lightGray,
    onBackground: eeireBlack,
    surface: snow,
    onSurface: eeireBlack
  ),
  iconTheme: const IconThemeData(
    color: eeireBlack,
    size: 20
  )
);
