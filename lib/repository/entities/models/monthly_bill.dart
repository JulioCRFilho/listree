import 'package:listree/repository/entities/types/types.dart';

class MonthlyBill extends Savable with Alarm, Money {
  MonthlyBill();

  factory MonthlyBill.fromMap(Map<String, dynamic> _map) => MonthlyBill()
    ..id = _map['id']
    ..title = _map['title']
    ..description = _map['description']
    ..dateTime = DateTime.parse(_map['dateTime'])
    ..dateLimit = DateTime.parse(_map['dateLimit'])
    ..repeat = _map['repeat']
    ..repeatCount = _map['repeatCount']
    ..value = double.tryParse(_map['value'].toString()) ?? 0;

  static List<MonthlyBill> fromList(List<dynamic> _list) {
    return _list.map((e) => MonthlyBill.fromMap(e)).toList();
  }
}
