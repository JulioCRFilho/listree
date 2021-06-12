import 'package:flutter/material.dart';

class ListItems extends StatelessWidget {
  final List items;

  const ListItems(this.items);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, i) => Dismissible(
        key: Key(items[i].toString()),
        confirmDismiss: _confirmDismiss,
        background: Container(color: Colors.red),
        child: _item(ctx, i),
      ),
    );
  }

  Row _item(BuildContext ctx, int i) {
    bool _showPin = false;
    bool _showOptions = false;

    final _shrinked = _showPin || _showOptions;

    return Row(
      children: [
        _showPin
            ? Container(
                height: 50,
                width: 50,
                color: Colors.blue,
                child: Icon(Icons.pin_drop),
              )
            : Container(),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            height: 50,
            color: Colors.grey,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'teste $i iuwhe ngodiq wjoidj auseh',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                _shrinked
                    ? Container()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '18/04/21',
                            maxLines: 1,
                          ),
                        ),
                      ),
                _shrinked
                    ? Container()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            'R\$ 18.50',
                            maxLines: 1,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _confirmDismiss(DismissDirection direction) async {
    switch (direction) {
      case DismissDirection.startToEnd:
        // setState(() {
        //   _showPin = !_showPin;
        // });
        break;
      case DismissDirection.endToStart:
        // setState(() {
        //   _showOptions = !_showOptions;
        // });
        break;
      default:
        {}
    }

    return false;
  }
}
