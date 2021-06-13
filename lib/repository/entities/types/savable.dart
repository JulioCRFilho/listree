abstract class Savable {
  late final int id;
  late final String _title;
  late final String description;

  Savable();

  /// Getters
  String get title => _title;

  /// Setters
  set title(String newTitle) {
    try {
      final exceed = newTitle.length - 12;
      _title = title.substring(0, exceed > 0 ? exceed : newTitle.length - 1);
    } catch (e) {
      throw e;
    }
  }
}
