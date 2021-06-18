import 'package:get/get.dart';

abstract class Drag {
  RxBool _showPin = false.obs;
  RxBool _showOptions = false.obs;

  /// Getters
  bool get showPin => _showPin.value;
  RxBool get showPinObs => _showPin;

  bool get showOptions => _showOptions.value;
  RxBool get showOptionsObs => _showOptions;

  /// Setters
  set showPin(bool _show) {
    _showPin.value = _show;
    _showOptions.value = false;
  }

  set showOptions(bool _show) {
    _showOptions.value = _show;
    _showPin.value = false;
  }
}