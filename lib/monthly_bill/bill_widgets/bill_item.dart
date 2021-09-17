import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:listree/monthly_bill/bill_widgets/bill_viewer.dart';
import 'package:listree/repository/datasources/dao/monthly_bills_dao.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:listree/widgets/collapsible_button.dart';

class BillItem extends StatelessWidget {
  final MonthlyBill _monthlyBill;

  const BillItem(this._monthlyBill);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(_monthlyBill.id.toString()),
      child: _item(),
      background: Container(color: Colors.cyan),
      secondaryBackground: Container(color: Colors.red),
      confirmDismiss: (direction) => _confirmDismiss(direction: direction),
    );
  }

  Widget _item() {
    return Obx(
      () {
        final bool _showPaid = _monthlyBill.showPaid;
        final bool _showOptions = _monthlyBill.showOptions;
        final bool _shrunken = _showPaid || _showOptions;

        return Row(
          children: [
            _paid(_showPaid),
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
              CollapsibleButton(
                color: Colors.redAccent,
                iconColor: Colors.white,
                icon: Icons.list_alt,
                onPress: () => BillViewer(_monthlyBill).show(),
              ),
              VerticalDivider(width: 2),
              CollapsibleButton(
                color: Colors.redAccent,
                iconColor: Colors.white,
                icon: Icons.delete,
                onPress: () async => await _deleteItem(),
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
        onTap: () => _monthlyBill.expand(),
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
                'R\$ ${_monthlyBill.formattedValue}',
                maxLines: 1,
              ),
            ),
          );
  }

  Widget _date(bool _shrunken) {
    final DateTime d = _monthlyBill.dueDate;
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
          _monthlyBill.title,
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

  Widget _paid(bool _showPaid) {
    return _showPaid
        ? Row(
            children: [
              VerticalDivider(width: 2),
              Obx(
                () => CollapsibleButton(
                  color: Colors.cyan,
                  iconColor: _monthlyBill.paid ? Colors.yellow : Colors.white,
                  icon: Icons.paid,
                  onPress: () => _setPaid(),
                ),
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
    _expandOthers();

    switch (direction) {
      case DismissDirection.startToEnd:
        _monthlyBill.showPaid = true;
        break;
      case DismissDirection.endToStart:
        _monthlyBill.showOptions = true;
        break;
      default:
        break;
    }

    return dismiss;
  }

  void _expandOthers() {
    final MonthlyBillsDAO _dao = Get.find();
    final List<MonthlyBill> _currentList = _dao.data;

    _currentList.forEach((item) {
      if (item.id != _monthlyBill.id) {
        item.expand();
      }
    });
  }

  void _setPaid() async =>
      await _monthlyBill.updatePaid(!_monthlyBill.paid, refreshData: false);

  Future<void> _deleteItem() async {
    final bool _deleted = await _monthlyBill.delete();
    await _confirmDismiss(dismiss: _deleted);
    // await Get.find<MonthlyBillsDAO>().updateData();
  }
}
