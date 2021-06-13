import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/widgets/item_tile.dart';

class ListItems extends StatelessWidget {
  final RxList items;

  const ListItems(this.items);

  @override
  Widget build(BuildContext context) {
    return items.length > 0
        ? ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) => Obx(() => ItemTile(items[i])))
        : Padding(
            padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nenhum item salvo nessa lista ainda.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
  }
}
