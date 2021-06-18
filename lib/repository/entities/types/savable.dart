import 'package:get/get.dart';

abstract class Savable {
  late final int id;

  RxString _title = ''.obs;
  RxString? description = ''.obs;
  RxBool _pinned = false.obs;

  /// Getters
  String get title => _title.value;

  bool get pinned => _pinned.value;

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
}
