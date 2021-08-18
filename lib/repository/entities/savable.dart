import 'package:get/get.dart';

abstract class Savable {
  late final int id;

  RxString _title = 'Sem título'.obs;
  RxString? _description = ''.obs;
  Rx<DateTime> _lastUpdate = DateTime.now().obs;

  /// Getters
  String get title => _title.value;

  String? get description => _description?.value;

  DateTime get lastUpdate => _lastUpdate.value;

  Rx<DateTime> get lastUpdateObs => _lastUpdate;

  String get lastUpdateString => [
        lastUpdate.day,
        lastUpdate.month.toString().padLeft(2, '0'),
        lastUpdate.year,
      ].join('/');

  DateTime get lastUpdateDate => _lastUpdate.value;

  /// Setters
  set title(String newTitle) => _title.value = newTitle;

  set description(String? _newValue) => _description?.value = _newValue ?? '';

  set lastUpdate(DateTime _newUpdate) => _lastUpdate.value = _newUpdate;
}
