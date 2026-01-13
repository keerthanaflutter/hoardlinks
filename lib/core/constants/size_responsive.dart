import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late Size _size;

  Responsive(this.context) {
    _size = MediaQuery.of(context).size;
  }

  double get width => _size.width;
  double get height => _size.height;

  /// Paddings
  double get paddingSmall => width * 0.02;
  double get paddingMedium => width * 0.04;

  /// AppBar
  double get appBarIconSize => width * 0.07;

  /// Bottom Navigation
  double get bottomNavHeight => height * 0.085;
  double get bottomNavRadius => bottomNavHeight / 2;
}
