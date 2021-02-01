library screens.term;

import 'package:flutter/material.dart';
import 'package:date/date.dart' as date;
import 'package:maya/models/term_model.dart';
import 'package:timezone/timezone.dart';
import 'package:provider/provider.dart';

class TermUi extends StatefulWidget {
  TermUi();

  @override
  State<StatefulWidget> createState() => _TermUiState();
}

class _TermUiState extends State<TermUi> {
  _TermUiState();

  String _error;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TermModel>();

    return Container(
        width: 140.0,
        child: TextFormField(
          initialValue: model.term.toString(),
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
                model.term = date.Term.parse(text, UTC);
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
