library screens.calculators.save_calculator;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:maya/models/existing/load_existing.dart';

class SaveCalculator extends StatefulWidget {
  SaveCalculator(this.json);
  final Map<String, dynamic> json;
  @override
  State<StatefulWidget> createState() => _SaveCalculatorState(json);
}

class _SaveCalculatorState extends State<SaveCalculator> {
  _SaveCalculatorState(this.json);
  final Map<String, dynamic> json;
  final LoadExisting model = LoadExisting(rootUrl: dotenv.env['rootUrl']!);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _calculatorNameController = TextEditingController();

  late String userId;
  late String calculatorName;

  @override
  Widget build(BuildContext context) {
    var _userSuggestions = <String>[];
    var _calcSuggestions = <String>[];

    return Form(
      key: _formKey,
      child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48.0),

              /// Employee Id
              Container(
                width: 200,
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _userIdController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'Employee Id')),
                  suggestionsCallback: (pattern) async {
                    var _allUsersCache = await model.getUsers();
                    _userSuggestions = _allUsersCache
                        .where((e) => e.contains(pattern.toLowerCase()))
                        .toList();
                    return _userSuggestions;
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (String suggestion) {
                    _userIdController.text = suggestion;
                    // no need to change the calculator name
                    userId = suggestion;
                  },
                  onSaved: (value) => userId = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a user' : null,
                  noItemsFoundBuilder: (context) => Text(' Unknown user',
                      style: TextStyle(color: Colors.red)),
                ),
              ),
              SizedBox(height: 24.0),

              /// Calculator name
              Container(
                width: 400,
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _calculatorNameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'Calculator name')),
                  suggestionsCallback: (pattern) async {
                    var _allCalculators =
                        await model.getCalculatorNames(userId);
                    _calcSuggestions = _allCalculators
                        .where((e) => e.contains(pattern.toLowerCase()))
                        .toList();
                    return _calcSuggestions;
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (String suggestion) {
                    _calculatorNameController.text = suggestion;
                    calculatorName = suggestion;
                  },
                  onSaved: (value) => calculatorName = value!,
                  validator: (value) => value!.isEmpty
                      ? 'Please type in a name for the calculator'
                      : null,
                  // TODO: show something if you overwrite an existing calculator
                  noItemsFoundBuilder: (context) =>
                      Text('', style: TextStyle(color: Colors.red)),
                ),
              ),
              SizedBox(height: 128.0),

              /// Save button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    var out = <String, dynamic>{
                      'userId': userId,
                      'calculatorName': calculatorName,
                      ...json,
                    };
                    await model.saveCalculator(out);
                    Navigator.pop(context);
                  }
                },
                child:
                    const Text('Save', style: TextStyle(color: Colors.black)),
              )
            ],
          )),
    );
  }
}
