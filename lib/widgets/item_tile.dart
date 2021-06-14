import 'package:flutter/material.dart';
import 'package:listree/widgets/item_button.dart';

class ItemTile extends StatelessWidget {
  final dynamic item;

  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id.toString()),
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
        _options(_showOptions),
      ],
    );
  }

  Widget _options(bool _showOptions) {
    return _showOptions
        ? Flexible(
            fit: FlexFit.loose,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ItemButton(
                  color: Colors.redAccent,
                  iconColor: Colors.grey,
                  icon: Icons.details,
                  onPress: () {},
                ),
                ItemButton(
                  color: Colors.redAccent,
                  iconColor: Colors.grey,
                  icon: Icons.edit,
                  onPress: () {},
                ),
                ItemButton(
                  color: Colors.redAccent,
                  iconColor: Colors.grey,
                  icon: Icons.delete,
                  onPress: () {},
                ),
              ],
            ),
          )
        : Container();
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
        : Container(
            width: 100,
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'R\$ ${item.formattedValue}',
                maxLines: 1,
              ),
            ),
          );
  }

  Widget _date(bool _shrunken, item) {
    final DateTime d = item.dateTime;
    final String date = '${d.day}/${d.month}/${d.year.toString().substring(2)}';
    return _shrunken
        ? Container()
        : Container(
            width: 80,
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                date,
                maxLines: 1,
              ),
            ),
          );
  }

  Widget _title(item) {
    return Expanded(
      child: Padding(
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
      ),
    );
  }

  Widget _pin(bool _showPin) {
    return _showPin
        ? ItemButton(
            color: Colors.blue,
            iconColor: Colors.grey,
            icon: Icons.location_pin,
            onPress: () {},
          )
        : Container();
  }

  Future<bool> _confirmDismiss(DismissDirection direction, item) async {
    if (direction == DismissDirection.startToEnd) {
      item
        ..showPin = true
        ..showOptions = false;
    }

    if (direction == DismissDirection.endToStart) {
      item
        ..showOptions = true
        ..showPin = false;
    }

    return false;
  }
}
