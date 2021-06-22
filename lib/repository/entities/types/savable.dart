import 'package:get/get.dart';

abstract class Savable {
  late final int id;

  RxString _title = ''.obs;
  RxString? _description = ''.obs;
  RxBool _pinned = false.obs;
  Rx<DateTime> _lastUpdate = DateTime.now().obs;

  /// Getters
  String get title => _title.value;

  bool get pinned => _pinned.value;

  String? get description => _description?.value;

  DateTime get lastUpdate => _lastUpdate.value;

  String get lastUpdateDate =>
      [lastUpdate.day, lastUpdate.month, lastUpdate.year].join('/');

  /// Setters
  set title(String newTitle) {
    try {
      final exceed = newTitle.length - 12;
      _title.value =
          newTitle.substring(0, exceed > 0 ? exceed : newTitle.length);
    } catch (e) {
      throw e;
    }
  }

  set pin(bool _pin) => _pinned.value = _pin;

  set description(String? _newValue) => _description?.value = _newValue ?? '';

  set lastUpdate(DateTime _newUpdate) => _lastUpdate.value = _newUpdate;
}
