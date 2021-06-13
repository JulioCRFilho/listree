import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final item;

  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.key),
      child: _item(item),
      background: Container(color: Colors.red),
      confirmDismiss: (direction) => _confirmDismiss(direction, item),
    );
  }

  Row _item(item) {
    final bool _showPin = item.showPin;
    final bool _showOptions = item.showOptions;
    final _shrunken = _showPin || _showOptions;

    return Row(
      children: [
        _pin(_showPin),
        _body(item, _shrunken),
        //TODO: implement options
      ],
    );
  }

  Expanded _body(item, bool _shrunken) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        height: 50,
        color: Colors.grey,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _title(item),
            _date(_shrunken, item),
            _value(_shrunken, item),
          ],
        ),
      ),
    );
  }

  Widget _value(bool _shrunken, item) {
    return _shrunken
        ? Container()
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                item.value,
                maxLines: 1,
              ),
            ),
          );
  }

  Widget _date(bool _shrunken, item) {
    return _shrunken
        ? Container()
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.date,
                maxLines: 1,
              ),
            ),
          );
  }

  Padding _title(item) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        item.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _pin(bool _showPin) {
    return _showPin
        ? InkWell(
            child: Container(
              height: 50,
              width: 50,
              color: Colors.blue,
              child: Icon(Icons.pin_drop),
            ),
          )
        : Container();
  }

  Future<bool> _confirmDismiss(DismissDirection direction, item) async {
    if (direction == DismissDirection.startToEnd) {
      item.showPin = true;
    }

    if (direction == DismissDirection.endToStart) {
      item.showOptions = true;
    }

    return false;
  }
}
