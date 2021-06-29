import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/repository/datasources/monthly_bills_dao.dart';
import 'package:listree/repository/entities/models/models.dart';

class ItemView {
  RxBool _editing = false.obs;

  final MonthlyBill _bill;
  final bool _creating;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _recurrent = TextEditingController();
  final TextEditingController _parcels = TextEditingController();
  final TextEditingController _lastUpdate = TextEditingController();

  late Rx<DateTime> _selectedDateTime;

  ItemView(this._bill, [this._creating = false]);

  void show() {
    _title.text = _bill.title;
    _description.text = _bill.description ?? '';
    _value.text = _bill.formattedValue;
    _recurrent.text = _bill.repeatCount != 0 ? 'Sim' : 'Não';
    _parcels.text = '${_bill.repeatCount} restantes';
    _lastUpdate.text = _bill.lastUpdateDate;
    _selectedDateTime = _bill.dateTime.obs;

    Get.dialog(
      AlertDialog(
        titlePadding: const EdgeInsets.all(2),
        contentPadding: const EdgeInsets.all(10),
        title: _head(),
        content: _content(),
      ),
    );
  }

  Padding _content() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _editableRow('Valor:', _value),
          Obx(() {
            final DateTime d = _selectedDateTime.value;
            final _dateTime = '${d.day}/${d.month}/${d.year}';

            return _dateTimeRow('Vencimento:', _dateTime);
          }),
          _editableRow('Recorrente:', _recurrent, editable: false),
          _editableRow('Parcelas:', _parcels),
          _editableRow('Descrição:', _description),
          _editableRow('Última atualização em:', _lastUpdate, editable: false)
        ],
      ),
    );
  }

  Column _head() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _editing.value || _creating
                  ? IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () => _updateOrCreateItem(),
                    )
                  : Container(),
              IconButton(
                icon: Icon(
                  _editing.value || _creating ? Icons.close : Icons.edit,
                ),
                onPressed: () {
                  if (_creating) {
                    Get.close(1);
                  } else {
                    _editing.value = !_editing.value;
                  }
                },
              ),
            ],
          ),
        ),
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _editing.value || _creating
                  ? Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _editable(_title, isTitle: true),
                      ),
                    )
                  : Flexible(
                      child: Text(
                        _bill.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _editableRow(
    String _label,
    TextEditingController _controller, {
    bool editable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_label),
            ),
          ),
          Obx(
            () => Flexible(
              child: _editing.value && editable || _creating && editable
                  ? _editable(_controller)
                  : Text(_controller.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editable(
    TextEditingController _controller, {
    bool isTitle = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(),
      ),
      padding: const EdgeInsets.all(4),
      child: EditableText(
        controller: _controller,
        textAlign: isTitle ? TextAlign.center : TextAlign.end,
        backgroundCursorColor: Colors.black,
        cursorColor: Colors.black,
        focusNode: FocusNode(),
        style: TextStyle(
          color: Colors.black,
          fontSize: isTitle ? 20 : 15,
        ),
      ),
    );
  }

  Future<void> _updateOrCreateItem() async {
    final value =
        double.tryParse(_value.text.substring(3).replaceAll(',', '.'));

    _bill
      ..title = _title.text
      ..description = _description.text
      ..dateTime = _selectedDateTime.value
      ..lastUpdate = DateTime.now()
      ..value = value ?? _bill.rawValue
      ..repeatCount =
          int.tryParse(_parcels.text.replaceAll(RegExp('[^0-9]'), '')) ??
              _bill.repeatCount;

    _creating ? await _bill.create() : await _bill.update();

    final MonthlyBillsDAO _dao = Get.find();
    final int _updatedList = _dao.data.length;

    if (_updatedList > 0) {
      _editing.value = false;
      await _dao.updateData();
      Get.close(1);
    } else {
      Get.showSnackbar(
        GetBar(
          title: 'Falha ao criar sua despesa.',
          message: 'Verifique as informações e tente novamente.',
        ),
      );
    }
  }

  Widget _dateTimeRow(String _label, String _dateTime) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_label),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () =>
                _editing.value || _creating ? _showDateTimePicker() : null,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: _editing.value || _creating ? Border.all() : null,
              ),
              padding: const EdgeInsets.all(4),
              child: Text(
                _dateTime,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showDateTimePicker() async {
    final _context = Get.context;
    if (_context == null) return;

    final dateTime = await showDatePicker(
      context: _context,
      initialDate: _selectedDateTime.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (dateTime != null) _selectedDateTime.value = dateTime;
  }
}
