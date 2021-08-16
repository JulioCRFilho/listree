import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:listree/widgets/date_time_picker.dart';

class BillViewer {
  RxBool _editing = false.obs;

  final MonthlyBill _bill;
  final bool creating, notification;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _recurrent = TextEditingController();
  final TextEditingController _parcels = TextEditingController();

  late final Rx<DateTime> _lastUpdate;
  late final Rx<DateTime> _selectedDateTime;

  BillViewer(
    this._bill, {
    this.creating = false,
    this.notification = false,
  }) {
    assert(!notification || !creating);
  }

  void show() async {
    _title.text = _bill.title;
    _description.text = _bill.description ?? '';
    _value.text = _bill.formattedValue;
    _recurrent.text = _bill.repeatCount > 1 ? 'Sim' : 'Não';
    _parcels.text = '${_bill.repeatCount} restantes';

    _lastUpdate = _bill.lastUpdate.obs;
    _selectedDateTime = _bill.dueDate.obs;

    await Get.dialog(
      AlertDialog(
        titlePadding: const EdgeInsets.all(2),
        contentPadding: const EdgeInsets.all(10),
        title: _head(),
        content: _content(),
      ),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _editableRow('Valor:', _value),
            _dateTimeRow('Vencimento:', DateTimeType.dateOnly),
            _dateTimeRow('Próximo alarme:', DateTimeType.dateTime,
                editable: false),
            _editableRow('Parcelas:', _parcels),
            _editableRow('Recorrente:', _recurrent, editable: false),
            _dateTimeRow('Última atualização:', DateTimeType.dateOnly,
                editable: false),
            _editableRow('Descrição:', _description, last: true),
          ],
        ),
      ),
    );
  }

  Widget _head() {
    return notification ? _notificationHead() : _editableHead();
  }

  Column _editableHead() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _editing.value || creating
                  ? IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () => _updateOrCreateItem(),
                    )
                  : Container(),
              IconButton(
                icon: Icon(
                  _editing.value || creating ? Icons.close : Icons.edit,
                ),
                onPressed: () {
                  if (creating) {
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
          () => Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _editing.value || creating
                  ? _editable(_title, isTitle: true)
                  : Text(
                      _bill.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _editableRow(
    String _label,
    TextEditingController _controller, {
    bool editable = true,
    bool last = false,
  }) {
    return last
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _editableWidgets(_label, editable, _controller, last),
          )
        : Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _editableWidgets(_label, editable, _controller, last),
          );
  }

  List<Widget> _editableWidgets(
    String _label,
    bool editable,
    TextEditingController _controller,
    bool last,
  ) {
    return [
      Flexible(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_label),
        ),
      ),
      Obx(
        () => Flexible(
          child: _editing.value && editable || creating && editable
              ? _editable(_controller, isLast: last)
              : Text(_controller.text),
        ),
      ),
    ];
  }

  Widget _editable(
    TextEditingController _controller, {
    bool isLast = false,
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
        backgroundCursorColor: Colors.black,
        cursorColor: Colors.black,
        maxLines: isLast ? 5 : 1,
        focusNode: FocusNode(),
        style: TextStyle(
          color: Colors.black,
          fontSize: isTitle ? 20 : 15,
        ),
        textAlign: isTitle
            ? TextAlign.center
            : isLast
                ? TextAlign.start
                : TextAlign.end,
      ),
    );
  }

  Future<void> _updateOrCreateItem() async {
    final value =
        double.tryParse(_value.text.substring(3).replaceAll(',', '.'));

    _bill
      ..title = _title.text
      ..description = _description.text
      ..dueDate = _selectedDateTime.value
      ..lastUpdate = DateTime.now()
      ..value = value ?? _bill.rawValue
      ..repeatCount =
          int.tryParse(_parcels.text.replaceAll(RegExp('[^0-9]'), '')) ??
              _bill.repeatCount;

    final bool _success =
        creating ? await _bill.create() : await _bill.update();

    if (_success) {
      _editing.value = false;
      Get.close(1);
    } else {
      final String errorMsg = !_bill.dueDateValid
          ? 'O vencimento deve ser posterior ao horário atual'
          : 'Verifique as informações e tente novamente. '
              'Se o problema persistir, contate o suporte.';

      Get.showSnackbar(
        GetBar(
          title: 'Falha ao inserir sua despesa.',
          message: errorMsg,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _dateTimeRow(
    String label,
    DateTimeType alarm, {
    bool editable = true,
    bool lastUpdate = false,
  }) {
    return Obx(() {
      final DateTime d =
          lastUpdate ? _lastUpdate.value : _selectedDateTime.value;

      late final String _dateTime;

      switch (alarm) {
        case DateTimeType.dateOnly:
          _dateTime =
              '${d.day}/${d.month.toString().padLeft(2, '0')}/${d.year}';
          break;

        case DateTimeType.dateTime:
          _dateTime = '${d.hour}:${d.minute.toString().padLeft(2, '0')}'
              ' ${d.day.toString().padLeft(2, '0')}'
              '/${d.month.toString().padLeft(2, '0')}';
          break;
      }

      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(label),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _editing.value && editable || creating && editable
                  ? _selectNewDateTime(_selectedDateTime.value)
                  : null,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: _editing.value && editable || creating && editable
                      ? Border.all()
                      : null,
                ),
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
    });
  }

  _selectNewDateTime(DateTime _current) async {
    final DateTime? _selected = await DateTimePicker.show(_current);
    if (_selected != null) _selectedDateTime.value = _selected;
  }

  Widget _notificationHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            //TODO: create logic to reduce parcels and reschedule with new date or delete based on repeat
          },
          child: Text('Confirmar pagamento'),
        ),
        ElevatedButton(
          onPressed: () {
            //TODO: reuse the reschedule with date tomorrow
          },
          child: Text('Repetir amanhã'),
        ),
      ],
    );
  }
}

enum DateTimeType {
  dateOnly,
  dateTime,
}
