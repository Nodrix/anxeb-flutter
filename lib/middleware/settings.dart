import 'package:flutter/material.dart';

class _Colors {
  Color primary = Color(0xff2e7db2);
  Color secudary = Color(0xff026299);
  Color accent = Color(0xffef6c00);
  Color success = Color(0xff4a934a);
  Color neutral = Color(0xff0c7272);
  Color info = Color(0xff333377);
  Color warning = Color(0xffffbb33);
  Color danger = Color(0xffff4444);
  Color asterisk = Color(0xff605156);
  Color active = Color(0xffffff99);
  Color tip = Color(0xffffffaf);
  Color link = Color(0xff0055ff);
  Color separator = Color(0xffcccccc);
  Color text = Color(0xff222222);
  Color header = Color(0xff195279);
  Color focus = Color(0x15111111);
  Color input = Color(0x10111111);
  Color navigation = Color(0xff053954);
}

class Settings {
  _Colors _colors;

  Settings() {
    _colors = _Colors();
  }

  _Colors get colors => _colors;
}