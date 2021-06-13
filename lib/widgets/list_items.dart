import 'package:flutter/material.dart';
import 'package:listree/widgets/item_tile.dart';

class ListItems extends StatelessWidget {
  final List items;

  const ListItems(this.items);

  @override
  Widget build(BuildContext context) {
    return items.length > 0
        ? ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) => ItemTile(items[i]))
        : Center(child: CircularProgressIndicator());
  }
}