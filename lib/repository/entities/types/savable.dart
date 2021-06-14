abstract class Savable {
  late final int id;
  late String _title;
  late String? description;

  Savable();

  /// Getters
  String get title => _title;

  /// Setters
  set title(String newTitle) {
    try {
      final exceed = newTitle.length - 12;
      _title = newTitle.substring(0, exceed > 0 ? exceed : newTitle.length);
    } catch (e) {
      throw e;
    }
  }
}
