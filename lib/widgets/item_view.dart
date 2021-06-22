import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/repository/entities/models/models.dart';

class ItemView {
  final MonthlyBill _bill;
  RxBool _editing = false.obs;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _deadline = TextEditingController();
  final TextEditingController _recurrent = TextEditingController();
  final TextEditingController _parcels = TextEditingController();
  final TextEditingController _lastUpdate = TextEditingController();

  ItemView(this._bill);

  void show() {
    _title.text = _bill.title;
    _description.text = _bill.description ?? '';
    _value.text = _bill.formattedValue;
    _deadline.text = _bill.dateTimeFormatted;
    _recurrent.text = _bill.repeatCount != 0 ? 'Sim' : 'Não';
    _parcels.text = '${_bill.repeatCount} restantes';
    _lastUpdate.text = _bill.lastUpdateDate;

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
          _editableRow('Vencimento:', _deadline),
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
              _editing.value
                  ? IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () => _updateItem(),
                    )
                  : Container(),
              IconButton(
                icon: Icon(_editing.value ? Icons.close : Icons.edit),
                onPressed: () => _editing.value = !_editing.value,
              ),
            ],
          ),
        ),
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _editing.value
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
              child: _editing.value && editable
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

  Future<void> _updateItem() async {
    _bill
      ..title = _title.text
      ..description = _description.text
      ..value = double.tryParse(_value.text) ?? _bill.rawValue
      ..dateTime = DateTime.tryParse(_deadline.text) ?? _bill.dateTime
      ..lastUpdate = DateTime.now()
      ..repeatCount =
          int.tryParse(_parcels.text.replaceAll(RegExp('[^0-9]'), '')) ??
              _bill.repeatCount;

    final bool _updated = await _bill.update();

    if (_updated) {
      _editing.value = false;
      Get.close(1);
    }
  }
}
