library screens.calculators.elec_swap.edit_quantity;

import 'package:date/date.dart';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:maya/models/edit_quantity.dart';
import 'package:maya/models/new/calculator_model/elec_swap.dart';
import 'package:timeseries/timeseries.dart';
import 'package:elec/src/time/hourly_schedule.dart';
import 'package:provider/provider.dart';

class EditQuantity extends StatefulWidget {
  EditQuantity(this.ts);
  final TimeSeries<num> ts;
  @override
  _EditQuantityState createState() => _EditQuantityState(ts);
}

class _EditQuantityState extends State<EditQuantity> {
  _EditQuantityState(this.ts);

  final _editableKey = GlobalKey<EditableState>();
  TimeSeries<num> ts;
  final _columns = [
    {'title': 'Month', 'widthFactor': 0.1, 'key': 'month', 'editable': false},
    {'title': 'MW', 'widthFactor': 0.1, 'key': 'mw'},
  ];

  @override
  Widget build(BuildContext context) {
    print('in EditQuantity ...');
    var rows = ts
        .map((e) => {
              'month': (e.interval as Month).toIso8601String(),
              'mw': e.value,
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
                width: 250,
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
                onPressed: () async {
                  var editedRows = _editableKey.currentState.editedRows;
                  print(editedRows);
                  await _updateQuantity(editedRows, ts);
                  Navigator.pop(context);
                },
                color: Theme.of(context).buttonColor),
          ],
        ),
      ],
    );
  }

  Future<void> _updateQuantity(List editedRows, TimeSeries<num> ts) async {
    setState(() {
      for (var er in editedRows) {
        int i = er['row'];
        var mw = num.tryParse(er['mw']) ?? 0;
        ts[i] = IntervalTuple<num>(ts[i].interval, mw);
      }
    });
  }
}
