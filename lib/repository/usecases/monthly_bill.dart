import 'package:get/get.dart';
import 'package:listree/repository/datasources/monthly_bills_dao.dart';
import 'package:listree/repository/entities/export.dart';
import 'package:listree/repository/datasources/interfaces/monthly_bill_interface.dart';

class MonthlyBill extends RxController
    with Alarm, Money, Savable, Drag
    implements MonthlyBillInterface {
  MonthlyBill();

  factory MonthlyBill.fromMap(Map<String, dynamic> _map) {
    return MonthlyBill()
      ..id = _map['id']
      ..title = _map['title']
      ..description = _map['description']
      ..dateTime = DateTime.parse(_map['dateTime'])
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
      'dateTime': dateTime.toIso8601String(),
      'repeatCount': repeatCount,
      'paid': paid ? 1 : 0,
      'lastUpdate': lastUpdate.toIso8601String(),
      'value':
          (int.tryParse(rawValue.toString().replaceAll('.', '')) ?? 0) / 100,
    };
  }

  @override
  Future<List<MonthlyBill>> get() async {
    final MonthlyBillsDAO _dao = Get.find();
    final List? _result = await _dao.get();
    return MonthlyBill.fromList(_result ?? []);
  }

  @override
  Future<bool> create({bool refreshData = true}) async {
    final MonthlyBillsDAO _dao = Get.find();
    return await _dao.insert(toMap, refreshData: refreshData);
  }

  @override
  Future<bool> update({bool refreshData = true}) async {
    final MonthlyBillsDAO _dao = Get.find();
    return await _dao.updateItem(id, toMap, refreshData: refreshData);
  }

  @override
  Future<bool> delete({bool refreshData = true}) async {
    final MonthlyBillsDAO _dao = Get.find();
    return await _dao.delete(id, refreshData: refreshData);
  }

  Future<void> updatePaid(bool _paid, {bool refreshData = true}) async {
    pay = _paid;

    final MonthlyBillsDAO _dao = Get.find();
    final _result = await _dao.updateItem(id, toMap, refreshData: refreshData);

    if (_result) {
      _dao.updatePaid(id);
    } else {
      pay = !_paid;
    }
  }
}