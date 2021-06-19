import 'package:get/get.dart';
import 'package:listree/repository/datasources/monthly_bills_dao.dart';
import 'package:listree/repository/entities/types/types.dart';
import 'package:listree/repository/interfaces/monthly_bill_interface.dart';

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
      ..pin = _map['pinned'] == 1
      ..showPin = _map['showPin'] ?? false;
  }

  static List<MonthlyBill> fromList(List<dynamic> _list) {
    return _list.map((e) => MonthlyBill.fromMap(e)).toList();
  }

  Map<String, dynamic> get toMap {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'repeatCount': repeatCount,
      'value': rawValue,
      'pinned': pinned ? 1 : 0,
    };
  }

  @override
  Future<List<MonthlyBill>> get() async {
    final MonthlyBillsDAO _dao = Get.find();
    final List? _result = await _dao.get();
    return MonthlyBill.fromList(_result ?? []);
  }

  @override
  Future<bool> create() async {
    final MonthlyBillsDAO _dao = Get.find();
    return await _dao.insert(toMap);
  }

  @override
  Future<bool> update() async {
    final MonthlyBillsDAO _dao = Get.find();
    return await _dao.updateItem(id, toMap);
  }

  @override
  Future<bool> delete() async {
    final MonthlyBillsDAO _dao = Get.find();
    return await _dao.delete(id);
  }

  Future<void> updatePin(bool _pin) async {
    pin = _pin;

    final MonthlyBillsDAO _dao = Get.find();
    final _result = await _dao.updateItem(id, toMap);

    if (_result) {
      _dao.updateData(id: id);
    } else {
      pin = !_pin;
    }
  }
}
