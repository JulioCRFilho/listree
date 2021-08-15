import 'package:get/get.dart';
import 'package:listree/repository/datasources/dao/monthly_bills_dao.dart';
import 'package:listree/repository/datasources/interfaces/monthly_bill_interface.dart';
import 'package:listree/repository/entities/export.dart';

class MonthlyBill extends RxController
    with Alarm, Money, Savable, Drag
    implements MonthlyBillInterface {
  MonthlyBill();

  factory MonthlyBill.fromMap(Map<String, dynamic> _map) {
    return MonthlyBill()
      ..id = _map['id']
      ..title = _map['title']
      ..description = _map['description']
      ..dueDate = DateTime.parse(_map['dateTime'])
      ..repeatCount = _map['repeatCount'] ?? 0
      ..value = double.tryParse(_map['value'].toString()) ?? 0
      ..pay = _map['paid'] == 1
      ..showPaid = _map['showPaid'] ?? false
      ..lastUpdate = DateTime.parse(_map['lastUpdate']);
  }

  static List<MonthlyBill> fromList(List<dynamic> _list) {
    return _list.map((e) => MonthlyBill.fromMap(e)).toList();
  }

  Map<String, dynamic> get toMap {
    return {
      'title': title,
      'description': description,
      'dateTime': dueDate.toIso8601String(),
      'repeatCount': repeatCount,
      'paid': paid ? 1 : 0,
      'lastUpdate': lastUpdate.toIso8601String(),
      'value':
          (int.tryParse(rawValue.toString().replaceAll('.', '')) ?? 0) / 100,
    };
  }

  @override
  Future<MonthlyBill> get() async {
    final MonthlyBillsDAO _dao = Get.find();
    final Map<String, dynamic> _result = await _dao.getById(id);
    return MonthlyBill.fromMap(_result);
  }

  @override
  Future<bool> create({bool refreshData = true}) async {
    if (!dueDateValid) return false;

    final MonthlyBillsDAO _dao = Get.find();
    final int _insertedId = await _dao.insert(toMap, refreshData: refreshData);
    final bool _success = _insertedId != 0;

    if (_success) {
      id = _insertedId;
      super.registerAlarm(this);
    }

    return _success;
  }

  @override
  Future<bool> update({bool refreshData = true}) async {
    if (!dueDateValid) return false;

    final MonthlyBillsDAO _dao = Get.find();
    final bool _updated =
        await _dao.updateItem(id, toMap, refreshData: refreshData);

    if (_updated) {
      await super.cancelAlarm(id);
      await super.registerAlarm(this);
    }

    return _updated;
  }

  @override
  Future<bool> delete({bool refreshData = true}) async {
    final MonthlyBillsDAO _dao = Get.find();
    final bool _deleted = await _dao.delete(id, refreshData: refreshData);

    if (_deleted) super.cancelAlarm(id);

    return _deleted;
  }

  @override
  Future<void> updatePaid(bool _paid, {bool refreshData = true}) async {
    pay = _paid;

    final MonthlyBillsDAO _dao = Get.find();
    final bool _updated =
        await _dao.updateItem(id, toMap, refreshData: refreshData);

    if (_updated) {
      _dao.updatePaid(id);
    } else {
      pay = !_paid;
    }
  }
}
