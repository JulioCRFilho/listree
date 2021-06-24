import 'package:get/get.dart';

abstract class Drag {
  RxBool _paid = false.obs;
  RxBool _showPaid = false.obs;
  RxBool _showOptions = false.obs;

  /// Getters
  bool get showPaid => _showPaid.value;

  bool get paid => _paid.value;

  bool get showOptions => _showOptions.value;

  /// Setters
  set showPaid(bool _show) {
    _showPaid.value = _show;
    _showOptions.value = false;
  }

  set showOptions(bool _show) {
    _showOptions.value = _show;
    _showPaid.value = false;
  }

  set pay(bool _pay) => _paid.value = _pay;

  /// Methods
  void expand() {
    _showPaid.value = false;
    _showOptions.value = false;
  }
}
