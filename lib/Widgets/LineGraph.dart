import 'package:flutter/material.dart';

import '../Models/Item.dart';

class LineGraph extends StatelessWidget {
  final List<Item> items;



  const LineGraph({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,


    );
  }
}
