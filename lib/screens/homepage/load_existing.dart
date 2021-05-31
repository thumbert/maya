library homepage.load_existing;

import 'package:elec/calculators/elec_daily_option.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:elec/calculators/elec_swap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:maya/models/existing/load_existing.dart';

class LoadExistingForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadExistingFormState();
}

class _LoadExistingFormState extends State<LoadExistingForm> {
  _LoadExistingFormState();
  final LoadExisting model = LoadExisting(rootUrl: dotenv.env['rootUrl']!);
  final _userIdController = TextEditingController();
  final _calculatorNameController = TextEditingController();

  late String userId;
  late String calculatorName;

  @override
  Widget build(BuildContext context) {
    var _userSuggestions = <String>[];
    var _calcSuggestions = <String>[];

    return Container(
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
                  // clear the calculator selection
                  _calculatorNameController.text = '';
                  userId = suggestion;
                },
                noItemsFoundBuilder: (context) =>
                    Text(' Unknown user', style: TextStyle(color: Colors.red)),
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
                  var _allCalculators = await model.getCalculatorNames(userId);
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
                noItemsFoundBuilder: (context) => Text(' Unknown calculator',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
            SizedBox(height: 128.0),

            /// Load button
            ElevatedButton(
              onPressed: () {
                // need to navigator it ...
                _loadCalculator();
              },
              child: const Text('Load', style: TextStyle(color: Colors.black)),
            )
          ],
        ));
  }

  void _loadCalculator() async {
    var aux = await model.getCalculator(userId, calculatorName);
    if (aux is ElecSwapCalculator) {
      print(aux.toJson());
      var json = aux.toJson();
      await Navigator.pushNamed(context, '/calculators', arguments: json);
    } else if (aux is ElecDailyOption) {
      print(aux.toJson());
      await Navigator.pushNamed(context, '/calculators',
          arguments: aux.toJson());
    }
  }
}
