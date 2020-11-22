import 'package:elec/calculators/elec_swap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:elec/elec.dart';
import 'package:elec/src/time/hourly_schedule.dart';
import 'package:timezone/browser.dart';

class LegRows extends StatefulWidget {
  LegRows(this.calculator, {Key key}) : super(key: key);

  final ElecSwapCalculator calculator;

  @override
  State<StatefulWidget> createState() => _LegRowsState(calculator);
}

class _LegRowsState extends State<LegRows> {
  _LegRowsState(this.calculator);

  ElecSwapCalculator calculator;
  final _qtyError = <String>[];
  final _regionError = <String>[];
  final _serviceError = <String>[];
  final _curveError = <String>[];
  final _fixPriceError = <String>[];

  final qtyControllers = <TextEditingController>[];
  final regionControllers = <TextEditingController>[];
  final serviceControllers = <TextEditingController>[];
  final curveControllers = <TextEditingController>[];
  final bucketControllers = <TextEditingController>[];
  final fixedPriceControllers = <TextEditingController>[];

  final _allBuckets = Bucket.buckets.keys.map((e) => e.toLowerCase()).toList();
  final _allRegions = ['isone'];

  var _bucketSuggestions = <String>[];

  @override
  void dispose() {
    for (var i = 0; i < calculator.legs.length; i++) {
      qtyControllers[i].dispose();
      regionControllers[i].dispose();
      serviceControllers[i].dispose();
      curveControllers[i].dispose();
      bucketControllers[i].dispose();
      fixedPriceControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < calculator.legs.length; i++) {
      _qtyError.add(null); // TODO: may need to check inputs
      _regionError.add(null);
      _serviceError.add(null);
      _curveError.add(null);
      _fixPriceError.add(null);
      qtyControllers.add(TextEditingController()
        ..text = calculator.legs[i].showQuantity().toString()
        ..addListener(() {}));
      regionControllers.add(TextEditingController()..text = 'isone');
      serviceControllers.add(TextEditingController()..text = 'energy');
      curveControllers.add(TextEditingController()..text = 'hub_da_lmp');
      bucketControllers.add(TextEditingController()..text = '5x16');
      fixedPriceControllers.add(TextEditingController()
        ..text = calculator.legs[i].showFixPrice().toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Table(columnWidths: {
      0: IntrinsicColumnWidth(), // qty
      1: IntrinsicColumnWidth(), // region
      2: IntrinsicColumnWidth(), // service
      3: IntrinsicColumnWidth(), // curve
      4: IntrinsicColumnWidth(), // bucket
      5: IntrinsicColumnWidth(), // fix price
      6: FixedColumnWidth(80), // price
      // 7: FixedColumnWidth(20), // menu
    }, children: [
      TableRow(children: header()),
      ...[
        for (var i = 0; i < calculator.legs.length; i++) ...[
          TableRow(children: commodityRow(i)),
          _rowSpacer,
        ]
      ],
    ]);
  }

  List<Widget> commodityRow(int row) {
    return [
      //quantity
      Container(
        margin: EdgeInsetsDirectional.only(end: _columnSpace),
        color: Colors.grey[300],
        child: TextField(
          controller: qtyControllers[row],
          onChanged: (value) {
            setState(() {
              var qty = num.tryParse(value);
              if (qty == null || value == '') {
                _qtyError[row] = 'Error';
              } else {
                _qtyError[row] = null;
                calculator.legs[row].quantitySchedule =
                    HourlySchedule.filled(qty);
              }
            });
          },
          textAlign: TextAlign.right,
          scrollPadding: EdgeInsets.all(5),
          decoration: InputDecoration(
            errorText: _qtyError[row],
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            errorBorder: _errorBorder,
            focusedErrorBorder: _errorBorder,
            border: _outlineInputBorder,
            enabledBorder: _outlineInputBorder,
          ),
        ),
      ),
      // Container(
      //     width: 100.0,
      //     margin: EdgeInsetsDirectional.only(end: _columnSpace),
      //     child: TypeAheadField(
      //       textFieldConfiguration: TextFieldConfiguration(
      //           controller: _regionController,
      //           decoration: InputDecoration(
      //               isDense: true,
      //               contentPadding: EdgeInsets.all(8),
      //               border: _outlineInputBorder,
      //               labelText: '')),
      //       suggestionsCallback: (pattern) {
      //         _regionSuggestions = _allRegions
      //             .where((e) => e.contains(pattern.toLowerCase()))
      //             .toList();
      //         if (_regionSuggestions.length == 1) {
      //           _regionController.text = _regionSuggestions.first;
      //         }
      //         return _regionSuggestions;
      //       },
      //       itemBuilder: (context, suggestion) {
      //         return ListTile(title: Text(suggestion));
      //       },
      //       transitionBuilder: (context, suggestionsBox, controller) {
      //         return suggestionsBox;
      //       },
      //       onSuggestionSelected: (suggestion) {
      //         print(suggestion);
      //         _regionController.text = suggestion;
      //       },
      //       noItemsFoundBuilder: (context) =>
      //           Text(' Invalid region', style: TextStyle(color: Colors.red)),
      //       // onSaved: (value) => _buckets[0] = value,
      //     )),
      // region
      Container(
        color: Colors.grey[300],
        margin: EdgeInsetsDirectional.only(end: _columnSpace),
        child: TextField(
          controller: regionControllers[row],
          onChanged: (value) {
            setState(() {
              if (value == '') {
                _regionError[row] = 'Error';
              } else {
                _regionError[row] = null;
              }
            });
          },
          scrollPadding: EdgeInsets.all(5),
          decoration: InputDecoration(
            errorText: _regionError[row],
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            errorBorder: _errorBorder,
            focusedErrorBorder: _errorBorder,
            border: _outlineInputBorder,
            enabledBorder: _outlineInputBorder,
          ),
        ),
      ),
      Container(
        color: Colors.grey[300],
        margin: EdgeInsetsDirectional.only(end: _columnSpace),
        child: TextField(
          controller: serviceControllers[row],
          onChanged: (value) {
            setState(() {
              if (value == '') {
                _serviceError[row] = 'Error';
              } else {
                _serviceError[row] = null;
              }
            });
          },
          scrollPadding: EdgeInsets.all(5),
          decoration: InputDecoration(
            errorText: _serviceError[row],
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            errorBorder: _errorBorder,
            focusedErrorBorder: _errorBorder,
            border: _outlineInputBorder,
            enabledBorder: _outlineInputBorder,
          ),
        ),
      ),
      Container(
        color: Colors.grey[300],
        margin: EdgeInsetsDirectional.only(end: _columnSpace),
        child: TextField(
          controller: curveControllers[row],
          onChanged: (value) {
            setState(() {
              if (value == '') {
                _curveError[row] = 'Error';
              } else {
                _curveError[row] = null;
              }
            });
          },
          scrollPadding: EdgeInsets.all(5),
          decoration: InputDecoration(
            errorText: _curveError[row],
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            errorBorder: _errorBorder,
            focusedErrorBorder: _errorBorder,
            border: _outlineInputBorder,
            enabledBorder: _outlineInputBorder,
          ),
        ),
      ),
      // bucket
      Container(
          color: Colors.grey[300],
          width: 100.0,
          margin: EdgeInsetsDirectional.only(end: _columnSpace),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: bucketControllers[row],
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    border: _outlineInputBorder,
                    enabledBorder: _outlineInputBorder,
                    labelText: '')),
            suggestionsCallback: (pattern) {
              _bucketSuggestions = _allBuckets
                  .where((e) => e.contains(pattern.toLowerCase()))
                  .toList();
              return _bucketSuggestions;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                bucketControllers[row].text = suggestion;
                calculator.legs[row].bucket = Bucket.parse(suggestion);
              });
            },
            noItemsFoundBuilder: (context) =>
                Text(' Invalid bucket', style: TextStyle(color: Colors.red)),
          )),
      // Fix price
      Container(
        color: Colors.grey[300],
        margin: EdgeInsetsDirectional.only(end: _columnSpace),
        child: TextField(
            controller: fixedPriceControllers[row],
            onChanged: (value) {
              setState(() {
                var qty = num.tryParse(value);
                if (qty == null || value == '') {
                  _fixPriceError[row] = 'Error';
                } else {
                  _fixPriceError[row] = null;
                  calculator.legs[row].fixPriceSchedule =
                      HourlySchedule.filled(qty);
                  print('Set fixPrice of leg $row to $qty');
                }
              });
            },
            textAlign: TextAlign.right,
            scrollPadding: EdgeInsets.all(5),
            decoration: InputDecoration(
                errorText: _fixPriceError[row],
                isDense: true,
                contentPadding: EdgeInsets.all(8),
                errorBorder: _errorBorder,
                focusedErrorBorder: _errorBorder,
                border: _outlineInputBorder,
                enabledBorder: _outlineInputBorder)),
      ),
      // Price
      ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 70,
            minHeight: 37,
          ),
          child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerRight,
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorLight),
              child: Text(
                '50.81',
                style: TextStyle(fontSize: 16),
              ))),
      // Menu
      Container(
          height: 36,
          alignment: Alignment.centerLeft,
          child: PopupMenuButton<int>(
            onSelected: (result) {
              if (result == 0) {
                addRow(row);
              } else if (result == 1) {
                removeRow(row);
              } else if (result == 2) {
                clearRow(row);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text('Add row'),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('Delete row'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Clear row'),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.orangeAccent),
                    Text('Customize quantity')
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.orangeAccent),
                    Text('Customize fix price')
                  ],
                ),
              ),
            ],
          )),
    ];
  }

  /// Add a new row after [row] index.
  void addRow(int row) {
    setState(() {
      var newLeg = calculator.legs[row].copy();
      calculator.legs.insert(row + 1, newLeg);
      print('Adding row: ${row + 1}');
      for (var leg in calculator.legs) {
        print(leg.toJson());
      }
      _qtyError.insert(row + 1, null);
      _regionError.insert(row + 1, null);
      _serviceError.insert(row + 1, null);
      _curveError.insert(row + 1, null);
      _fixPriceError.insert(row + 1, null);
      qtyControllers.insert(
          row + 1,
          TextEditingController()
            ..text = calculator.legs[row + 1].showQuantity().toString()
            ..addListener(() {}));
      regionControllers.insert(
          row + 1, TextEditingController()..text = regionControllers[row].text);
      serviceControllers.insert(row + 1,
          TextEditingController()..text = serviceControllers[row].text);
      curveControllers.insert(
          row + 1, TextEditingController()..text = curveControllers[row].text);
      bucketControllers.insert(
          row + 1, TextEditingController()..text = bucketControllers[row].text);
      fixedPriceControllers.insert(
          row + 1,
          TextEditingController()
            ..text = calculator.legs[row + 1].showFixPrice().toString());
    });
  }

  /// Clear all inputs [row] from the table.  Calculator won't price.
  void clearRow(int row) {
    setState(() {
      qtyControllers[row].text = '';
      fixedPriceControllers[row].text = '';
    });
  }

  /// Remove [row] from the table.
  void removeRow(int row) {
    setState(() {
      if (calculator.legs.length > 1) {
        calculator.legs.removeAt(row);
        _qtyError.removeAt(row);
        _regionError.removeAt(row);
        _serviceError.removeAt(row);
        _curveError.removeAt(row);
        _fixPriceError.removeAt(row);
        qtyControllers.removeAt(row);
        regionControllers.removeAt(row);
        serviceControllers.removeAt(row);
        curveControllers.removeAt(row);
        bucketControllers.removeAt(row);
        fixedPriceControllers.removeAt(row);
      }
    });
  }

  List<Widget> header() {
    var _style = TextStyle(fontSize: 18, color: Theme.of(context).primaryColor);
    return [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.bottom,
          child: Container(
              margin: EdgeInsetsDirectional.only(end: _columnSpace),
              padding: EdgeInsetsDirectional.only(bottom: 4),
              child: Text('Hourly\nQuantity   ', style: _style))),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: Container(
          margin: EdgeInsetsDirectional.only(end: _columnSpace),
          padding: EdgeInsetsDirectional.only(bottom: 4),
          child: Text(
            'Region',
            style: _style,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: Container(
            margin: EdgeInsetsDirectional.only(end: _columnSpace),
            padding: EdgeInsetsDirectional.only(bottom: 4),
            child: Text('Service   ', style: _style)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: Container(
          margin: EdgeInsetsDirectional.only(end: _columnSpace),
          padding: EdgeInsetsDirectional.only(bottom: 4),
          child: Text(
            '\nCurve                   ', // 24 chars
            style: _style,
          ),
        ),
      ),
      // Text('\nCurve', style: _style),
      Text('\nBucket   ', style: _style),
      Text('Fixed\nPrice   ', style: _style),
      Text('\nPrice   ', style: _style),
      Text(''),
    ];
  }

  // other details
  final _backgroundColor = Colors.grey[300];
  final _columnSpace = 12.0;
  final _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.zero),
    borderSide: BorderSide(color: Colors.grey[300], width: 1),
  );
  final _errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  );
  final _rowSpacer = TableRow(children: [
    SizedBox(height: 4),
    SizedBox(height: 4),
    SizedBox(height: 4),
    SizedBox(height: 4),
    SizedBox(height: 4),
    SizedBox(height: 4),
    SizedBox(height: 4),
    SizedBox(height: 4),
  ]);
}
