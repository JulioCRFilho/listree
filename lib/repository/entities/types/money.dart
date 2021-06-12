abstract class Money {
  double _rawValue = 0.00;
  String _prefix = 'R\$';
  String _formatedValue = 'R\$ 0,00';

  /// Getters
  double get rawValue => _rawValue;

  String get prefix => _prefix;

  String get formatedValue => _formatedValue;

  /// Setters
  set value(double? newValue) {
    final String? _parsedValue = newValue?.toStringAsFixed(2);
    //TODO: implement currency format method

    if (newValue == null || _parsedValue == null) return;

    _rawValue = newValue;
    _formatedValue = _parsedValue;
  }
}