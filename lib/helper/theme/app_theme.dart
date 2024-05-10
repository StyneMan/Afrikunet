import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appTheme = ThemeData(
  primaryColor: Constants.primaryColor,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
    backgroundColor: Constants.secondaryColor,
  ),
  textTheme: const TextTheme(
    bodyText2: TextStyle(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(elevation: 0.0),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all<Color?>(Colors.white),
    fillColor: MaterialStateProperty.all<Color?>(Constants.primaryColor),
    splashRadius: 1.0,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  inputDecorationTheme: const InputDecorationTheme(
    focusColor: Constants.primaryColor,
    filled: true,
    // fillColor: Color(0xFFEDF8F9),
    // labelStyle: TextStyle(
    //   color: Constants.primaryColor,
    // ),
    hintStyle: TextStyle(
      color: Colors.black38,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Constants.primaryColor,
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Constants.primaryColor,
    foregroundColor: Constants.primaryColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    circularTrackColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: Constants.secondaryColor,
    secondary: Constants.secondaryColor,
    background: Colors.white,
    tertiary: Colors.grey[800],
    inversePrimary: Colors.black54,
    primaryContainer: Constants.primaryColor,
    inverseSurface: Constants.primaryColor,
    surface: Colors.white,
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: Constants.primaryColor2,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ),
    backgroundColor: Color(0xFF1F1F1F),
  ),
  brightness: Brightness.dark,
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: Colors.grey[800],
    ),
    bodyMedium: TextStyle(color: Colors.grey[800]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(elevation: 0.0),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all<Color?>(Colors.white),
    fillColor: MaterialStateProperty.all<Color?>(Constants.primaryColor2),
    splashRadius: 1.0,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  inputDecorationTheme: const InputDecorationTheme(
    focusColor: Constants.primaryColor2,
    filled: true,
    // fillColor: Color(0xFFEDF8F9),
    // labelStyle: TextStyle(
    //   color: Constants.primaryColor,
    // ),
    hintStyle: TextStyle(color: Color(0x5F6F6C6C)),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Constants.primaryColor2,
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Constants.primaryColor2,
    foregroundColor: Constants.primaryColor2,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    circularTrackColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF1F1F1F),
    secondary: Colors.white70,
    background: Color(0xDD080808),
    tertiary: Colors.white,
    inversePrimary: Color(0xFF4C4C4C),
    primaryContainer: Color.fromARGB(255, 188, 171, 171),
    surface: Color(0xFF1F1F1F),
    inverseSurface: Colors.white,
  ),
);
