import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/repository/entities/models/models.dart';

class ItemView {
  final MonthlyBill _bill;
  RxBool _editing = false.obs;

  ItemView(this._bill);

  void show() => Get.dialog(
        AlertDialog(
          titlePadding: const EdgeInsets.all(2),
          contentPadding: const EdgeInsets.all(10),
          title: _title(),
          content: _content(),
        ),
      );

  Padding _content() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _editableRow('Valor:', _bill.formattedValue),
          _editableRow('Vencimento:', _bill.dateTimeFormatted),
          _editableRow('Recorrente:', _bill.repeatCount != 0 ? 'Sim' : 'Não'),
          _editableRow('Parcelas:', '${_bill.repeatCount} restantes'),
        ],
      ),
    );
  }

  Column _title() {
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
                      onPressed: () {},
                    )
                  : Container(),
              IconButton(
                icon: Icon(_editing.value ? Icons.close : Icons.edit),
                onPressed: () => _editing.value = !_editing.value,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                _bill.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _editableRow(String _label, dynamic _value) {
    final TextEditingController _controller =
        TextEditingController(text: '$_value');

    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(_label)),
          Obx(
            () => Flexible(
              child: _editing.value
                  ? TextFormField(
                      initialValue: '$_value',
                      textAlign: TextAlign.end,
                    )
                  : Text('$_value'),
            ),
          ),
        ],
      ),
    );
  }
}
