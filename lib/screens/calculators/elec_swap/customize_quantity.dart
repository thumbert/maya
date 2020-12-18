library screens.calculators.elec_swap.customize_quanitity;

import 'package:date/date.dart';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:maya/models/calculator_model.dart';
import 'package:provider/provider.dart';

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

class EditQuantity extends StatelessWidget {
  EditQuantity(this.rowIndex);

  final _editableKey = GlobalKey<EditableState>();
  final int rowIndex;
  final _columns = [
    {'title': 'Month', 'widthFactor': 0.1, 'key': 'month', 'editable': false},
    {'title': 'MWh', 'widthFactor': 0.1, 'key': 'mwh'},
  ];

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CalculatorModel>();

    var aux = model.legs[rowIndex].quantity;
    var rows = aux
        .map((e) => {
              'month': (e.interval as Month).toIso8601String(),
              'mwh': e.value,
            })
        .toList();

    var table = Editable(
      key: _editableKey,
      columns: _columns,
      rows: rows,
      borderColor: Theme.of(context).primaryColorLight,
      zebraStripe: false,
      stripeColor2: Colors.white,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(0))),
    );

    return SimpleDialog(
      title: Text('Customize quantity',
          style: TextStyle(color: Theme.of(context).primaryColor)),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 400,
                width: 230,
                padding: EdgeInsets.all(10),
                child: table),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  var editedRows = _editableKey.currentState.editedRows;
                  print(editedRows);
                  Navigator.pop(context);
                },
                color: Theme.of(context).buttonColor),
          ],
        ),
      ],
    );
  }
}
