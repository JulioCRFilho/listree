import 'package:listree/repository/entities/types/types.dart';

class MonthlyBill extends Savable with Alarm, Money {
  MonthlyBill() : super();

  factory MonthlyBill.fromMap(Map<String, dynamic> _map) => MonthlyBill()
    ..title = _map['title']
    ..description = _map['description']
    ..dateTime = DateTime.parse(_map['dateTime'])
    ..dateLimit = DateTime.parse(_map['dateLimit'])
    ..repeat = _map['repeat']
    ..repeatCount = _map['repeatCount']
    ..value = double.tryParse(_map['value'].toString());
}
