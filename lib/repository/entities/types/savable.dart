import 'dart:math';

import 'package:flutter/material.dart';

abstract class Savable {
  final Key _key;

  String _title = '';
  String? description;

  Savable(this._key);

  /// Getters
  String get title => _title;

  /// Setters
  set title(String newTitle) {
    final exceed = newTitle.length - 12;
    _title = title.substring(0, exceed > 0 ? exceed : newTitle.length - 1);
  }

  //TODO: implement sharedPrefs methods
}
