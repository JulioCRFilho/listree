import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listree/widgets/list_items.dart';

class Home extends StatelessWidget {
  final list = List.generate(20, (index) => index); //TODO: remove mock

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listree'),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: ListItems(list),
    );
  }
}
