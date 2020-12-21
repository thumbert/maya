import 'package:elec/calculators/elec_swap.dart';
import 'package:flutter/material.dart';
import 'package:date/date.dart' as date;
import 'package:timezone/timezone.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:maya/models/new/calculator_model.dart';

class AsOfDateUi extends StatefulWidget {
  AsOfDateUi();

  @override
  State<StatefulWidget> createState() => _AsOfDateState();
}

class _AsOfDateState extends State<AsOfDateUi> {
  _AsOfDateState();

  String _error;
  bool notToday;

  @override
  Widget build(BuildContext context) {
    final calculator = context.watch<CalculatorModel>();
    notToday = calculator.asOfDate != date.Date.today();
    return Container(
        width: 164.0,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: notToday
                ? Border.all(color: Theme.of(context).buttonColor, width: 3)
                : null),
        child: TextFormField(
          initialValue: calculator.asOfDate.toString(DateFormat('dMMMyy')),
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
                calculator.asOfDate = aux;
                if (calculator.asOfDate.isAfter(date.Date.today())) {
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
