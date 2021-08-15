import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateTimePicker {
  static Future<DateTime?> show(
    DateTime _selectedDateTime, {
    int maxDate = 2050,
  }) async {
    final BuildContext? _context = Get.context;
    if (_context == null) return Future.value(DateTime.now());

    final DateTime? dateTime = await showDatePicker(
          context: _context,
          initialDate: _selectedDateTime,
          firstDate: DateTime.now(),
          lastDate: DateTime(maxDate),
          initialEntryMode: DatePickerEntryMode.calendarOnly,
        );

    if (dateTime == null) return Future.value();

    final Duration subtractToZero = Duration(
      hours: dateTime.hour,
      minutes: dateTime.minute,
      seconds: dateTime.second,
    );

    final DateTime zeroHourDateTime = dateTime.subtract(subtractToZero);

    final TimeOfDay? alarmTime =
        await showTimePicker(context: _context, initialTime: TimeOfDay.now());

    if (alarmTime == null) return Future.value();

    final Duration alarmTimeDuration = Duration(
      hours: alarmTime.hour,
      minutes: alarmTime.minute,
    );

    final DateTime selectedDateTime = zeroHourDateTime.add(alarmTimeDuration);

    return selectedDateTime;
  }
}
