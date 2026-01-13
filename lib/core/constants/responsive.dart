import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late Size _size;

  Responsive(this.context) {
    _size = MediaQuery.of(context).size;
  }

  double get width => _size.width;
  double get height => _size.height;
}


