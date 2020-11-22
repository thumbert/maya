import 'package:elec/calculators/elec_swap.dart';
import 'package:flutter/material.dart';
import 'package:date/date.dart' as date;
import 'package:timezone/timezone.dart';

class TermUi extends StatefulWidget {
  TermUi(this.calculator);

  final ElecSwapCalculator calculator;

  @override
  State<StatefulWidget> createState() => _TermUiState(calculator);
}

class _TermUiState extends State<TermUi> {
  _TermUiState(this.calculator);

  ElecSwapCalculator calculator;
  bool _termError = false;

  @override
  Widget build(BuildContext context) {
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
            errorText: _termError ? 'Parsing error' : null,
          ),
          onChanged: (text) {
            setState(() {
              try {
                calculator.term = date.Term.parse(text, UTC);
                _termError = false;
              } on ArgumentError catch (_) {
                _termError = true;
              } catch (e) {}
            });
          },
        ));
  }
}
