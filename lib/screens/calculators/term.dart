import 'package:elec/calculators/elec_swap.dart';
import 'package:flutter/material.dart';
import 'package:date/date.dart' as date;
import 'package:timezone/timezone.dart';
import 'package:provider/provider.dart';
import 'package:maya/models/new/calculator_model.dart';

class TermUi extends StatefulWidget {
  TermUi();

  @override
  State<StatefulWidget> createState() => _TermUiState();
}

class _TermUiState extends State<TermUi> {
  _TermUiState();

  bool _termError = false;
  String _error;

  @override
  Widget build(BuildContext context) {
    final calculator = context.watch<CalculatorModel>();

    return Container(
        width: 140.0,
        child: TextFormField(
          initialValue: calculator.term.toString(),
          decoration: InputDecoration(
            labelText: 'Term',
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
                calculator.term = date.Term.parse(text, UTC);
                _error = null;
              } on ArgumentError catch (_) {
                _error = 'Parsing error';
              } catch (e) {
                print(e);
              }
            });
          },
        ));
  }
}
