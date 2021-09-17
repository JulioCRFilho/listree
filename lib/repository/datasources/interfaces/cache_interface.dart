mixin CacheInterface<T> {
  final List<T?> _recoverableList = [];

  List<T?> get recoverableList => _recoverableList;

  T? get recoverLastItemCached =>
      _recoverableList.isNotEmpty ? _recoverableList.last : null;

  set addItemToRecoverableList(T item) {
    _recoverableList.add(item);

    for (int i = 0; i < _recoverableList.length; i++) {
      print('recoverable ${_recoverableList[i]}');
    }
  }

  void removeRecoveredCached() {
    if (_recoverableList.isNotEmpty) _recoverableList.removeLast();
  }
}
