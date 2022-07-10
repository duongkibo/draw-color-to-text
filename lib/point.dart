import 'package:flutter/material.dart';

class Point {
  Point(this.offset, this.time);
  Offset offset;
  double time;

  @override
  String toString() {
    return '$offset, $time';
  }
}
