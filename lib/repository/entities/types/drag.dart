abstract class Drag {
  bool _showPin = false;
  bool _showOptions = false;

  /// Getters
  bool get showPin => _showPin;

  bool get showOptions => _showOptions;

  /// Setters
  set showPin(bool _show) {
    _showPin = _show;
    _showOptions = false;
  }

  set showOptions(bool _show) {
    _showOptions = _show;
    _showPin = false;
  }
}