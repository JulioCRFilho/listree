abstract class Alarm {
  DateTime? dateTime;
  DateTime? _dateLimit;
  bool repeat = false;
  int _repeatCount = 0;

  /// Getters
  DateTime? get dateLimit => _dateLimit;

  int get repeatCount => _repeatCount;

  ///Setters
  set dateLimit(DateTime? newDateLimit) {
    if (dateTime == null) return;

    final bool isAfter = newDateLimit?.isAfter(dateTime!) ?? false;
    if (isAfter) _dateLimit = newDateLimit;
  }

  set repeatCount(int newCount) {
    if (repeat) _repeatCount = newCount;
  }

  //TODO: implement alarm manager
}
