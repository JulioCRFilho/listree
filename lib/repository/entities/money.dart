import 'package:get/get.dart';

abstract class Money {
  late RxDouble _rawValue = 0.0.obs;
  late final String _prefix = 'R\$';
  late RxString _formattedValue = 'R\$ 0,00'.obs;

  /// Getters
  double get rawValue => _rawValue.value;

  String get prefix => _prefix;

  String get formattedValue => _formattedValue.value;

  /// Setters
  set value(double newValue) {
    //TODO: implement local currency format method

    _rawValue.value = newValue;
    _formattedValue.value = '$_prefix $newValue';
  }
}
