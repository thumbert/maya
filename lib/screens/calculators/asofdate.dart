library screens.calculators.asofdate;

import 'package:flutter/material.dart';
import 'package:date/date.dart' as date;
import 'package:timezone/timezone.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:maya/models/asofdate_model.dart';

class AsOfDateUi extends StatefulWidget {
  AsOfDateUi();

  @override
  State<StatefulWidget> createState() => _AsOfDateState();
}

class _AsOfDateState extends State<AsOfDateUi> {
  _AsOfDateState();

  String? _error;
  late bool notToday;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AsOfDateModel>();
    notToday = model.asOfDate != date.Date.today(location: UTC);
    return Container(
        width: 164.0,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: notToday
                ? Border.all(color: Theme.of(context).buttonColor, width: 3)
                : null),
        child: TextFormField(
          initialValue: model.asOfDate.toString(DateFormat('dMMMyy')),
          decoration: InputDecoration(
            labelText: 'As of date',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            helperText: '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            errorText: _error,
          ),
          onChanged: (text) {
            setState(() {
              var aux = date.Date.tryParse(text, location: UTC);
              if (aux == null) {
                _error = 'Parsing error';
              } else {
                model.asOfDate = aux;
                if (model.asOfDate.isAfter(date.Date.today(location: UTC))) {
                  _error = 'Date is from the future';
                } else {
                  _error = null; // all good
                }
              }
            });
          },
        ));
  }
}
