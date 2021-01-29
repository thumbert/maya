library homepage.load_existing;

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:maya/models/existing/load_existing.dart';

class LoadExistingForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadExistingFormState();
}

class _LoadExistingFormState extends State<LoadExistingForm> {
  _LoadExistingFormState();
  final LoadExisting model = LoadExisting();
  final _userIdController = TextEditingController();
  final _calculatorNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String userId;
    String calculatorName;
    var _userSuggestions = <String>[];
    var _calcSuggestions = <String>[];

    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.0),
            // Text(
            //   'Load an existing calculator',
            //   style: TextStyle(fontSize: 24),
            // ),
            SizedBox(height: 24.0),

            /// Employee Id
            Container(
              width: 200,
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _userIdController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        labelText: 'Employee Id')),
                suggestionsCallback: (pattern) async {
                  var _allUsersCache = await model.getUsers();
                  _userSuggestions = _allUsersCache
                      .where((e) => e.contains(pattern.toLowerCase()))
                      .toList();
                  return _userSuggestions;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  _userIdController.text = suggestion;
                  userId = suggestion;
                },
                noItemsFoundBuilder: (context) =>
                    Text(' Unknown user', style: TextStyle(color: Colors.red)),
              ),
            ),

            /// Calculator name
            Container(
              width: 400,
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _calculatorNameController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        labelText: 'Calculator name')),
                suggestionsCallback: (pattern) async {
                  var _allCalculators = await model.getCalculatorNames(userId);
                  _calcSuggestions = _allCalculators
                      .where((e) => e.contains(pattern.toLowerCase()))
                      .toList();
                  return _calcSuggestions;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  _calculatorNameController.text = suggestion;
                  calculatorName = suggestion;
                },
                noItemsFoundBuilder: (context) => Text(' Unknown calculator',
                    style: TextStyle(color: Colors.red)),
              ),

              // child: TextField(
              //   decoration:
              //       InputDecoration(filled: true, labelText: 'Calculator name'),
              // ),
            ),
            SizedBox(height: 128.0),
            RaisedButton(
              child: Text('Load'),
              onPressed: () {
                // need to navigator it ...
              },
              color: Theme.of(context).buttonColor,
              // textColor: Colors.black,
            )
          ],
        ));
  }

  // void showCalculators() async {
  //   var child = SimpleDialog(
  //     title: Text('${model.userId}\'s calculators:'),
  //     children: [
  //       SimpleDialogOption(
  //           child: ListTile(
  //               title: Text('First one'),
  //               leading: GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 child: Icon(
  //                   Icons.label_important_outlined,
  //                   color: Theme.of(context).primaryColor,
  //                 ),
  //               )))
  //     ],
  //   );
  //
  //   final value = await showDialog(
  //     context: context,
  //     builder: (context) => child,
  //   );
  // }
}
