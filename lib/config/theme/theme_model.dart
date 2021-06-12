import 'package:flutter/material.dart';

abstract class ThemeModel {
  Color get primary;
  Color get secondary;
  MaterialColor get swatch;

  Color get primaryDark;
  Color get secondaryDark;

  Color get primaryLight;
  Color get secondaryLight;

  double get titleSize;
  double get subtitleSize;
  double get bodySize;
}