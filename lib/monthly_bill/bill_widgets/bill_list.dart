import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/monthly_bill/bill_widgets/bill_item.dart';

class BillList extends StatelessWidget {
  final RxList items;

  const BillList(this.items);

  @override
  Widget build(BuildContext context) {
    return Obx(() => items.length > 0
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(),
              _bodyList(),
            ],
          )
        : _emptyList());
  }

  Flexible _bodyList() {
    return Flexible(
              child: Obx(
                () => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => BillItem(items[i]),
                ),
              ),
            );
  }

  Padding _emptyList() {
    return Padding(
          padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nenhum item salvo nessa lista ainda.',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
  }

  Container _header() {
    return Container(
      color: Colors.blueGrey,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: const Text('Título')),
            Container(
              width: 80,
              alignment: Alignment.centerRight,
              child: const Text('Vencimento'),
            ),
            Container(
              width: 100,
              alignment: Alignment.centerRight,
              child: const Text('Valor'),
            ),
          ],
        ),
      ),
    );
  }
}
