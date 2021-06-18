import 'package:get/get.dart';

abstract class Savable {
  late final int id;
  RxString _title = ''.obs;
  RxString? description = ''.obs;

  /// Getters
  String get title => _title.value;

  /// Setters
  set title(String newTitle) {
    try {
      final exceed = newTitle.length - 12;
      _title.value = newTitle.substring(0, exceed > 0 ? exceed : newTitle.length);
    } catch (e) {
      throw e;
    }
  }
}
