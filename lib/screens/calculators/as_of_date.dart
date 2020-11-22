import 'package:elec/calculators/elec_swap.dart';
import 'package:flutter/material.dart';
import 'package:date/date.dart' as date;
import 'package:timezone/timezone.dart';
import 'package:intl/intl.dart';

class AsOfDateUi extends StatefulWidget {
  AsOfDateUi(this.calculator);

  final ElecSwapCalculator calculator;

  @override
  State<StatefulWidget> createState() => _AsOfDateState(calculator);
}

class _AsOfDateState extends State<AsOfDateUi> {
  _AsOfDateState(this.calculator);

  ElecSwapCalculator calculator;
  String _error;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 140.0,
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
              try {
                // TODO: have a dedicated date parser to allow for
                // inputs like: 5/29/2020, 2020-05-29, 29May20
                var aux = date.Term.parse(text, UTC);
                if (aux.isOneDay()) {
                  calculator.asOfDate = aux.startDate;
                } else {
                  _error = 'Parsing error';
                }
                if (calculator.asOfDate.isAfter(date.Date.today())) {
                  _error = 'Date is from the future';
                } else {
                  _error = null;
                }
              } on ArgumentError catch (_) {
                _error = 'Parsing error';
              } catch (e) {}
            });
          },
        ));
  }
}
