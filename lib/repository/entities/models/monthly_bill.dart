import 'package:get/get.dart';
import 'package:listree/repository/entities/types/drag.dart';
import 'package:listree/repository/entities/types/types.dart';

class MonthlyBill extends RxController with Alarm, Money, Savable, Drag {
  MonthlyBill();

  factory MonthlyBill.fromMap(Map<String, dynamic> _map) => MonthlyBill()
    ..id = _map['id']
    ..title = _map['title']
    ..description = _map['description']
    ..dateTime = DateTime.parse(_map['dateTime'])
    ..repeatCount = _map['repeatCount'] ?? 0
    ..value = double.tryParse(_map['value'].toString()) ?? 0;

  static List<MonthlyBill> fromList(List<dynamic> _list) {
    return _list.map((e) => MonthlyBill.fromMap(e)).toList();
  }
}
