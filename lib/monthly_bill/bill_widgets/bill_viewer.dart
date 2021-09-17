import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/repository/usecases/export.dart';
import 'package:listree/widgets/date_time_picker.dart';

class BillViewer {
  final MonthlyBill _bill;

  final RxBool _editing = false.obs;
  final RxBool _creating = false.obs;
  final RxBool _notification = false.obs;

  final Rx<DateTime> _selectedDate = DateTime.now().obs;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _parcels = TextEditingController();
  final TextEditingController _recurrent = TextEditingController();
  final TextEditingController _description = TextEditingController();

  BillViewer(
    this._bill, {
    bool creating = false,
    bool notification = false,
  }) {
    assert(!notification || !creating);
    _creating.value = creating;
    _notification.value = notification;
  }

  void show() async {
    _updateControllers();

    await Get.dialog(
      AlertDialog(
        titlePadding: const EdgeInsets.all(2),
        contentPadding: const EdgeInsets.all(10),
        title: _head(),
        content: _content(),
      ),
      barrierDismissible: !_notification.value,
    );
  }

  void _updateControllers() {
    _title.text = _bill.title;
    _description.text = _bill.description ?? '';
    _price.text = _bill.formattedValue;
    _recurrent.text = _bill.repeatCount > 1 ? 'Sim' : 'Não';
    _parcels.text = _bill.repeatCount.toString();

    _selectedDate.value = _bill.dueDate;
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _editableRow(
              'Valor:',
              _bill.formattedValue,
              _price,
            ),
            _dateTimeRow(
              'Vencimento:',
              _selectedDate,
              DateTimeType.dateOnly,
            ),
            _dateTimeRow(
              'Próximo alarme:',
              //TODO: implement selectedAlarmDateTime into MonthlyBill
              _selectedDate,
              DateTimeType.dateTime,
              editable: false,
            ),
            _editableRow(
              'Parcelas:',
              _bill.repeatCount.toString(),
              _parcels,
            ),
            _editableRow(
              'Recorrente:',
              _bill.repeatCount > 1 ? 'Sim' : 'Não',
              _recurrent,
              editable: false,
            ),
            _dateTimeRow(
              'Última atualização:',
              _bill.lastUpdateObs,
              DateTimeType.dateOnly,
              editable: false,
            ),
            _editableRow(
              'Descrição:',
              _bill.description ?? '',
              _description,
              last: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _head() =>
      Obx(() => _notification.value ? _notificationHead() : _editableHead());

  Column _editableHead() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _editing.value || _creating.value
                  ? IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () => _updateOrCreateItem(),
                    )
                  : Container(),
              IconButton(
                icon: Icon(
                  _editing.value || _creating.value ? Icons.close : Icons.edit,
                ),
                onPressed: () {
                  if (_creating.value) {
                    Get.close(1);
                  } else {
                    _updateControllers();
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
              child: _editing.value || _creating.value
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
    String _value,
    TextEditingController _controller, {
    bool editable = true,
    bool last = false,
  }) {
    return last
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                _editableWidgets(_label, _value, editable, _controller, last),
          )
        : Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                _editableWidgets(_label, _value, editable, _controller, last),
          );
  }

  List<Widget> _editableWidgets(
    String _label,
    String _value,
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
          child: _editing.value && editable || _creating.value && editable
              ? _editable(_controller, isLast: last)
              : Text(_value),
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
        double.tryParse(_price.text.substring(3).replaceAll(',', '.'));

    _bill
      ..title = _title.text
      ..description = _description.text
      ..dueDate = _selectedDate.value
      ..lastUpdate = DateTime.now()
      ..value = value ?? _bill.rawValue
      ..repeatCount =
          int.tryParse(_parcels.text.replaceAll(RegExp('[^0-9]'), '')) ??
              _bill.repeatCount;

    final bool _success =
        _creating.value ? await _bill.create() : await _bill.update();

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
    Rx<DateTime> dateTime,
    DateTimeType dateType, {
    bool editable = true,
  }) {
    return Obx(() {
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
              onTap: () =>
                  _editing.value && editable || _creating.value && editable
                      ? _selectNewDateTime(_selectedDate.value)
                      : null,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border:
                      _editing.value && editable || _creating.value && editable
                          ? Border.all()
                          : null,
                ),
                child: Text(
                  _parseDateTime(dateTime.value, dateType),
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
    if (_selected != null) _selectedDate.value = _selected;
  }

  Widget _notificationHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          child: Text('Confirmar pagamento'),
          onPressed: () async {
            _bill.updatePaid(true, refreshData: false);

            if (_bill.repeatCount > 1) {
              _bill.repeatCount = _bill.repeatCount - 1;
              await _rescheduleForNextMonth();
            } else {
              _bill.repeatCount = 0;

              await Get.defaultDialog(
                title: 'Deseja remover essa despesa?',
                middleText: 'Esta despesa não possui mais parcelas',
                barrierDismissible: false,
                textCancel: 'Manter despesa',
                textConfirm: 'Remover',
                onCancel: () async => await _rescheduleForNextMonth(),
                onConfirm: () async {
                  await _bill.delete();
                  Get.close(2);
                },
              );
            }
          },
        ),
        ElevatedButton(
          child: Text('Repetir amanhã'),
          onPressed: () async => await _rescheduleBill(Duration(days: 1)),
        ),
      ],
    );
  }

  Future<void> _rescheduleForNextMonth() async {
    final current = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(current.year, current.month);
    final month = Duration(days: daysInMonth);

    await _rescheduleBill(month);
  }

  Future<void> _rescheduleBill(Duration _duration) async {
    _bill.dueDate = _bill.dueDate.add(_duration);
    final bool _updated = await _bill.update();

    print('mes agendado: ${_bill.dueDate}');

    if (!_updated) {
      return await Get.showSnackbar(
        GetBar(
          duration: Duration(seconds: 3),
          title: 'Falha ao reagendar sua despesa',
          message:
              'Acesse os detalhes da despesa e reagende manualmente selecionando uma nova data.',
        ),
      );
    }

    await _bill.registerAlarm<MonthlyBill>(_bill);
    _updateControllers();
    Get.close(1);
  }
}

String _parseDateTime(DateTime d, DateTimeType type) {
  switch (type) {
    case DateTimeType.dateOnly:
      return '${d.day}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    case DateTimeType.dateTime:
      return '${d.hour}:${d.minute.toString().padLeft(2, '0')}'
          ' ${d.day.toString().padLeft(2, '0')}'
          '/${d.month.toString().padLeft(2, '0')}';
  }
}

enum DateTimeType {
  dateOnly,
  dateTime,
}
