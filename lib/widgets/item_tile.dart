import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:listree/widgets/item_button.dart';

class ItemTile extends StatelessWidget {
  final dynamic item;

  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id.toString()),
      child: _item(),
      background: Container(color: Colors.blue),
      secondaryBackground: Container(color: Colors.red),
      confirmDismiss: (direction) => _confirmDismiss(direction),
    );
  }

  Widget _item() {
    return Obx(
      () {
        final bool _showPin = item.showPin;
        final bool _showOptions = item.showOptions;
        final bool _shrunken = _showPin || _showOptions;

        return Row(
          children: [
            _pin(_showPin),
            _body(_shrunken),
            _options(_showOptions),
          ],
        );
      },
    );
  }

  Widget _options(bool _showOptions) {
    return _showOptions
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VerticalDivider(width: 2),
              ItemButton(
                color: Colors.redAccent,
                iconColor: _showOptions ? Colors.white : Colors.green,
                icon: Icons.details,
                onPress: () => hideMenus(),
              ),
              VerticalDivider(width: 2),
              ItemButton(
                color: Colors.redAccent,
                iconColor: _showOptions ? Colors.white : Colors.green,
                icon: Icons.edit,
                onPress: () => hideMenus(),
              ),
              VerticalDivider(width: 2),
              ItemButton(
                color: Colors.redAccent,
                iconColor: _showOptions ? Colors.white : Colors.green,
                icon: Icons.delete,
                onPress: () => hideMenus(),
              ),
              VerticalDivider(width: 2),
            ],
          )
        : Container();
  }

  Expanded _body(bool _shrunken) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        height: 50,
        color: Colors.grey[300],
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _title(),
            _date(_shrunken),
            _value(_shrunken),
          ],
        ),
      ),
    );
  }

  Widget _value(bool _shrunken) {
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

  Widget _date(bool _shrunken) {
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

  Widget _title() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          item.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _pin(bool _showPin) {
    return _showPin
        ? Row(
            children: [
              VerticalDivider(width: 2),
              ItemButton(
                color: Colors.blue,
                iconColor: _showPin ? Colors.white : Colors.green,
                icon: Icons.location_pin,
                onPress: () => hideMenus(),
              ),
              VerticalDivider(width: 2),
            ],
          )
        : Container();
  }

  Future<bool> _confirmDismiss(DismissDirection direction) async {
    switch (direction) {
      case DismissDirection.startToEnd:
        item.showPin = true;
        break;
      case DismissDirection.endToStart:
        item.showOptions = true;
        break;
      default:
        break;
    }

    return false;
  }

  hideMenus() {
    item.showPin = false;
    item.showOptions = false;

    //TODO: remove this mock and implement the real functions
  }
}
