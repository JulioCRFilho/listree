abstract class Alarm {
  late DateTime dateTime;
  late DateTime _dateLimit;
  late bool repeat;
  late int _repeatCount;

  /// Getters
  DateTime get dateLimit => _dateLimit;

  int get repeatCount => _repeatCount;

  ///Setters
  set dateLimit(DateTime newDateLimit) {
    try {
      final bool isAfter = newDateLimit.isAfter(dateTime);
      if (isAfter) _dateLimit = newDateLimit;
    } catch (e) {
      throw e;
    }
  }

  set repeatCount(int newCount) {
    if (repeat)
      throw Exception('Repeat must be true to set a repeat count');
    else
      _repeatCount = newCount;
  }

//TODO: implement alarm manager
}
