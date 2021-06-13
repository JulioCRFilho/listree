abstract class Money {
  late double _rawValue;
  late final String _prefix = 'R\$';
  late String _formattedValue = 'R\$ 0,00';

  /// Getters
  double get rawValue => _rawValue;

  String get prefix => _prefix;

  String get formattedValue => _formattedValue;

  /// Setters
  set value(double newValue) {
    try {
      final String _parsedValue =
          newValue.toStringAsFixed(2); //TODO: remove mock
      //TODO: implement currency format method

      _rawValue = newValue;
      _formattedValue = _parsedValue;
    } catch (e) {
      throw e;
    }
  }
}
