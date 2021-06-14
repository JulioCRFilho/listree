abstract class Alarm {
  late DateTime dateTime;
  late DateTime? _dateLimit;
  late int repeatCount = 0;

  /// Getters
  DateTime? get dateLimit => _dateLimit;

  ///Setters
  set dateLimit(DateTime? newDateLimit) {
    try {
      final bool isAfter = newDateLimit?.isAfter(dateTime) ?? false;
      if (isAfter) _dateLimit = newDateLimit;
    } catch (e) {
      throw e;
    }
  }

//TODO: implement alarm manager
}
