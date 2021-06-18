import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:listree/repository/datasources/monthly_bills_dao.dart';
import 'package:listree/repository/entities/models/models.dart';
import 'package:listree/widgets/item_button.dart';

class ItemTile extends StatelessWidget {
  final MonthlyBill item;

  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id.toString()),
      child: _item(),
      background: Container(color: Colors.blue),
      secondaryBackground: Container(color: Colors.red),
      confirmDismiss: (direction) => _confirmDismiss(direction: direction),
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
                iconColor: Colors.white,
                icon: Icons.list_alt,
                onPress: () => showDetails(),
              ),
              VerticalDivider(width: 2),
              ItemButton(
                color: Colors.redAccent,
                iconColor: Colors.white,
                icon: Icons.delete,
                onPress: () => deleteItem(),
              ),
              VerticalDivider(width: 2),
            ],
          )
        : Container();
  }

  Expanded _body(bool _shrunken) {
    return Expanded(
      child: InkWell(
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
        onTap: () => item.expand(),
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
                iconColor: item.pinned ? Colors.green : Colors.white,
                icon: Icons.location_pin,
                onPress: () => fixBill(),
              ),
              VerticalDivider(width: 2),
            ],
          )
        : Container();
  }

  Future<bool> _confirmDismiss({
    DismissDirection direction = DismissDirection.none,
    bool dismiss = false,
  }) async {
    expandOthers();

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

    return dismiss;
  }

  void expandOthers() {
    final MonthlyBillsDAO _dao = Get.find();
    final List<MonthlyBill> _currentList = _dao.data;

    _currentList.forEach((bill) {
      if (bill.id != item.id) {
        bill.expand();
      }
    });
  }

  void fixBill() {
    //TODO: implement correct method and call _confirmDismiss(dismiss: true) after that.
  }

  void showDetails() {
    //TODO: implement correct method and call _confirmDismiss(dismiss: true) after that.
  }

  void deleteItem() {
    //TODO: implement correct method and call _confirmDismiss(dismiss: true) after that.
  }
}
