import 'package:get/get.dart';

abstract class Alarm {
  Rx<DateTime> _dateTime = DateTime.now().obs;
  RxInt _repeatCount = 0.obs;

  /// Getters
  DateTime get dateTime => _dateTime.value;

  String get dateTimeFormatted => [
        dateTime.day,
        dateTime.month,
        dateTime.year,
      ].join('/');

  int get repeatCount => _repeatCount.value;

  ///Setters
  set dateTime(DateTime newDateTime) => _dateTime.value = newDateTime;

  set repeatCount(int value) {
    _repeatCount.value = value;
  }

//TODO: implement alarm manager
}
