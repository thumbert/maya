library screens.calculators.elec_swap.customize_quantity;

import 'package:flutter/material.dart';

class CustomizeQuantity extends StatefulWidget {
  CustomizeQuantity(this.rowIndex);
  final int rowIndex;
  @override
  _CustomizeQuantityState createState() => _CustomizeQuantityState(rowIndex);
}

class _CustomizeQuantityState extends State<CustomizeQuantity>
    with SingleTickerProviderStateMixin {
  _CustomizeQuantityState(this.rowIndex);

  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: Text('Customize quantity'), children: [
      SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop('edit_values');
          },
          child: ListTile(
              title: Text('Edit values'),
              leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  Icons.label_important_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ))),
      SimpleDialogOption(
        onPressed: () {
          Navigator.of(context, rootNavigator: false).pop('import_file');
        },
        child: ListTile(
          title: Text('Import from file'),
          leading: Icon(
            Icons.label_important_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
    ]);
  }
}
