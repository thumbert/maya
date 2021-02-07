import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:elec/elec.dart';
import 'package:maya/screens/calculators/elec_swap/customize_quantity.dart';
import 'package:provider/provider.dart';
import 'package:maya/models/new/calculator_model/elec_daily_option.dart';

class LegRows extends StatefulWidget {
  LegRows({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LegRowsState();
}

class _LegRowsState extends State<LegRows> {
  _LegRowsState();

  final _qtyError = <String>[];
  final _regionError = <String>[];
  final _curveError = <String>[];
  final _strikeError = <String>[];
  final _priceAdjustError = <String>[];
  final _volAdjustError = <String>[];
  final _fixPriceError = <String>[];

  final qtyControllers = <TextEditingController>[];
  final regionControllers = <TextEditingController>[];
  final curveControllers = <TextEditingController>[];
  final bucketControllers = <TextEditingController>[];
  final callPutControllers = <TextEditingController>[];
  final strikeControllers = <TextEditingController>[];
  final priceAdjControllers = <TextEditingController>[];
  final volAdjControllers = <TextEditingController>[];
  final fixedPriceControllers = <TextEditingController>[];

  final _allBuckets = Bucket.buckets.keys.map((e) => e.toLowerCase()).toList();
  var _bucketSuggestions = <String>[];

  @override
  void dispose() {
    final calculator = context.read<CalculatorModel>();
    for (var i = 0; i < calculator.legs.length; i++) {
      qtyControllers[i].dispose();
      regionControllers[i].dispose();
      curveControllers[i].dispose();
      bucketControllers[i].dispose();
      callPutControllers[i].dispose();
      strikeControllers[i].dispose();
      priceAdjControllers[i].dispose();
      volAdjControllers[i].dispose();
      fixedPriceControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final calculator = context.read<CalculatorModel>();

    for (var i = 0; i < calculator.legs.length; i++) {
      _qtyError.add(null); // TODO: may need to check inputs
      _regionError.add(null);
      _curveError.add(null);
      _strikeError.add(null);
      _priceAdjustError.add(null);
      _volAdjustError.add(null);
      _fixPriceError.add(null);
      qtyControllers.add(TextEditingController()
        ..text = calculator.legs[i].showQuantity().toString()
        ..addListener(() {}));
      regionControllers.add(TextEditingController()..text = 'isone');
      curveControllers.add(TextEditingController()..text = 'hub_da_lmp');
      bucketControllers
          .add(TextEditingController()..text = calculator.legs[i].bucket.name);
      callPutControllers.add(TextEditingController()
        ..text = calculator.legs[i].callPut.toString().toLowerCase());
      strikeControllers.add(TextEditingController()
        ..text = calculator.legs[i].strike.values.first
            .toString()); // FIXME: strike is a timeseries!
      var _priceAdj = calculator.legs[i].priceAdjustment.values.first;
      priceAdjControllers.add(TextEditingController()
        ..text = _priceAdj == 0 ? '' : _priceAdj.toString());
      var _volAdj = calculator.legs[i].volatilityAdjustment.values.first;
      volAdjControllers.add(TextEditingController()
        ..text = _volAdj == 0 ? '' : _volAdj.toString());
      var _fP = calculator.legs[i].showFixPrice();
      fixedPriceControllers
          .add(TextEditingController()..text = _fP == 0 ? '' : _fP.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final calculator = context.watch<CalculatorModel>();

    return Table(columnWidths: {
      0: IntrinsicColumnWidth(), // qty
      1: IntrinsicColumnWidth(), // region
      2: IntrinsicColumnWidth(), // curve
      3: IntrinsicColumnWidth(), // bucket
      4: IntrinsicColumnWidth(), // call/put
      5: IntrinsicColumnWidth(), // strike
      6: IntrinsicColumnWidth(), // underlying
      7: IntrinsicColumnWidth(), // priceAdjust
      8: IntrinsicColumnWidth(), // volAdjust
      9: IntrinsicColumnWidth(), // fix price
      10: IntrinsicColumnWidth(), // price
      // 11: FixedColumnWidth(20), // menu
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
    final model = context.watch<CalculatorModel>();
    var leg = model.legs[row];

    return [
      /// Quantity
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
                  model.setQuantity(row, qty);
                }
              });
            },
            textAlign: TextAlign.right,
            scrollPadding: EdgeInsets.all(5),
            decoration: _getDecoration(_qtyError[row])),
      ),

      /// Region
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
          decoration: _getDecoration(_regionError[row]),
        ),
      ),

      /// Curve
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
            decoration: _getDecoration(_curveError[row])),
      ),

      /// Bucket
      Container(
          color: Colors.grey[300],
          width: 100.0,
          margin: EdgeInsetsDirectional.only(end: _columnSpace),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: bucketControllers[row],
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(12),
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
              bucketControllers[row].text = suggestion;
              leg.bucket = Bucket.parse(suggestion);
              model.setLeg(row, leg);
            },
            noItemsFoundBuilder: (context) =>
                Text(' Invalid bucket', style: TextStyle(color: Colors.red)),
          )),

      /// Call/Put
      Container(
          color: Colors.grey[300],
          width: 70.0,
          margin: EdgeInsetsDirectional.only(end: _columnSpace),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: callPutControllers[row],
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(12),
                    border: _outlineInputBorder,
                    enabledBorder: _outlineInputBorder,
                    labelText: '')),
            suggestionsCallback: (pattern) {
              return {'call', 'put'}
                  .where((e) => e.contains(pattern.toLowerCase()))
                  .toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              callPutControllers[row].text = suggestion;
              leg.callPut = CallPut.parse(suggestion);
              model.setLeg(row, leg);
            },
            noItemsFoundBuilder: (context) =>
                Text(' Invalid choice', style: TextStyle(color: Colors.red)),
          )),

      /// Strike
      ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 55,
            minHeight: 36,
          ),
          child: Container(
            margin: EdgeInsetsDirectional.only(end: _columnSpace),
            color: Colors.grey[300],
            child: TextField(
                controller: strikeControllers[row],
                onChanged: (value) {
                  setState(() {
                    var strike = num.tryParse(value);
                    if (strike == null || value == '' || strike <= 0) {
                      _strikeError[row] = 'Error';
                    } else {
                      _strikeError[row] = null;
                      model.setStrike(row, strike);
                    }
                  });
                },
                textAlign: TextAlign.right,
                scrollPadding: EdgeInsets.all(5),
                decoration: _getDecoration(_strikeError[row])),
          )),

      /// Underlying price
      ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 70,
            minHeight: 36,
          ),
          child: Container(
              margin: EdgeInsetsDirectional.only(end: _columnSpace),
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerRight,
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorLight),
              child: FutureBuilder<String>(
                future: _getUnderlyingPrice(row, model),
                builder: (context, snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = [
                      Text(
                        snapshot.data,
                        style: TextStyle(fontSize: 16),
                      )
                    ];
                  } else if (snapshot.hasError) {
                    children = [
                      Icon(Icons.error_outline, color: Colors.red),
                      Text(
                        'Error',
                        style: TextStyle(fontSize: 16),
                      )
                    ];
                  } else {
                    children = [
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))
                    ];
                  }
                  return Row(
                    children: children,
                    mainAxisAlignment: MainAxisAlignment.end,
                  );
                },
              ))),

      /// Price Adjust
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 55,
          minHeight: 36,
        ),
        child: Container(
          margin: EdgeInsetsDirectional.only(end: _columnSpace),
          color: Colors.grey[300],
          child: TextField(
              controller: priceAdjControllers[row],
              onChanged: (value) {
                setState(() {
                  if (value == '') {
                    model.setPriceAdjustment(row, 0);
                    _priceAdjustError[row] = null;
                  } else {
                    var priceAdj = num.tryParse(value);
                    if (priceAdj == null) {
                      _priceAdjustError[row] = 'Error';
                    } else {
                      _priceAdjustError[row] = null;
                      model.setPriceAdjustment(row, priceAdj);
                    }
                  }
                });
              },
              textAlign: TextAlign.right,
              scrollPadding: EdgeInsets.all(5),
              decoration: _getDecoration(_priceAdjustError[row])),
        ),
      ),

      /// Vol Adjust
      ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 55,
            minHeight: 36,
          ),
          child: Container(
            margin: EdgeInsetsDirectional.only(end: _columnSpace),
            color: Colors.grey[300],
            child: TextField(
                controller: volAdjControllers[row],
                onChanged: (value) {
                  setState(() {
                    if (value == '') {
                      model.setVolAdjustment(row, 0);
                      _volAdjustError[row] = null;
                    } else {
                      var volAdj = num.tryParse(value);
                      if (volAdj == null) {
                        _volAdjustError[row] = 'Error';
                      } else {
                        _volAdjustError[row] = null;
                        model.setVolAdjustment(row, volAdj);
                      }
                    }
                  });
                },
                textAlign: TextAlign.right,
                scrollPadding: EdgeInsets.all(5),
                decoration: _getDecoration(_volAdjustError[row])),
          )),

      /// Fix price
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 55,
          minHeight: 36,
        ),
        child: Container(
          color: Colors.grey[300],
          margin: EdgeInsetsDirectional.only(end: _columnSpace),
          child: TextField(
              controller: fixedPriceControllers[row],
              onChanged: (value) {
                setState(() {
                  if (value == '') {
                    model.setFixPrice(row, 0);
                    _fixPriceError[row] = null;
                  } else {
                    var fp = num.tryParse(value);
                    if (fp == null) {
                      _fixPriceError[row] = 'Error';
                    } else {
                      _fixPriceError[row] = null;
                      model.setFixPrice(row, fp);
                    }
                  }
                });
              },
              textAlign: TextAlign.right,
              scrollPadding: EdgeInsets.all(5),
              decoration: _getDecoration(_fixPriceError[row])),
        ),
      ),

      /// Price
      ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 60,
            minHeight: 36,
          ),
          child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerRight,
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorLight),
              child: FutureBuilder<String>(
                future: _getPrice(row, model),
                builder: (context, snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = [
                      Text(
                        snapshot.data,
                        style: TextStyle(fontSize: 16),
                      )
                    ];
                  } else if (snapshot.hasError) {
                    children = [
                      Icon(Icons.error_outline, color: Colors.red),
                      Text(
                        'Error',
                        style: TextStyle(fontSize: 16),
                      )
                    ];
                  } else {
                    children = [
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))
                    ];
                  }
                  return Row(
                    children: children,
                    mainAxisAlignment: MainAxisAlignment.end,
                  );
                },
              ))),

      /// Menu with actions (end of row)
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
              } else if (result == 3) {
                _onCustomizeQuantity(row);
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

  /// get the price of the underlying leg
  Future<String> _getUnderlyingPrice(int row, CalculatorModel model) async {
    await model.build();
    var leg = model.legs[row];
    return leg.showUnderlyingPrice().toStringAsFixed(2);
  }

  /// get the price of the option leg
  Future<String> _getPrice(int row, CalculatorModel model) async {
    await model.build();
    var leg = model.legs[row];
    return leg.price().toStringAsFixed(2);
  }

  void _onCustomizeQuantity(int row) async {
    var child = CustomizeQuantity(row);
    var value = await showDialog(
      context: context,
      builder: (context) => child,
    );
    print('value: $value');
    if (value == 'edit_values') {
      print('Will edit by hand!');
      // await showDialog(
      //   context: context,
      //   builder: (context) => EditQuantity(row),
      // );
    } else if (value == 'input_file') {
      print('Will read from file');
    }
  }

  /// Add a new row after [row] index.
  void addRow(int row) {
    final calculator = context.read<CalculatorModel>();

    var newLeg = calculator.legs[row].copyWith();
    calculator.addLeg(row + 1, newLeg);
    // print('Adding row: ${row + 1}');

    _qtyError.insert(row + 1, null);
    _regionError.insert(row + 1, null);
    _curveError.insert(row + 1, null);
    _strikeError.insert(row + 1, null);
    _priceAdjustError.insert(row + 1, null);
    _volAdjustError.insert(row + 1, null);
    _fixPriceError.insert(row + 1, null);
    qtyControllers.insert(
        row + 1,
        TextEditingController()
          ..text = calculator.legs[row + 1].showQuantity().toString()
          ..addListener(() {}));
    regionControllers.insert(
        row + 1, TextEditingController()..text = regionControllers[row].text);
    curveControllers.insert(
        row + 1, TextEditingController()..text = curveControllers[row].text);
    bucketControllers.insert(
        row + 1, TextEditingController()..text = bucketControllers[row].text);
    callPutControllers.insert(
        row + 1, TextEditingController()..text = callPutControllers[row].text);
    strikeControllers.insert(
        row + 1, TextEditingController()..text = strikeControllers[row].text);
    priceAdjControllers.insert(
        row + 1, TextEditingController()..text = priceAdjControllers[row].text);
    volAdjControllers.insert(
        row + 1, TextEditingController()..text = volAdjControllers[row].text);
    fixedPriceControllers.insert(row + 1,
        TextEditingController()..text = fixedPriceControllers[row].text);

    // fixedPriceControllers.insert(
    //     row + 1,
    //     TextEditingController()
    //       ..text = calculator.legs[row + 1].showFixPrice().toString());
  }

  /// Clear all inputs [row] from the table.  Calculator won't price.
  void clearRow(int row) {
    qtyControllers[row].text = '';
    fixedPriceControllers[row].text = '';
  }

  /// Remove [row] from the table.
  void removeRow(int row) {
    final calculator = context.read<CalculatorModel>();

    if (calculator.legs.length > 1) {
      calculator.removeLeg(row);
      _qtyError.removeAt(row);
      _regionError.removeAt(row);
      _curveError.removeAt(row);
      _strikeError.removeAt(row);
      _priceAdjustError.removeAt(row);
      _volAdjustError.removeAt(row);
      _fixPriceError.removeAt(row);

      qtyControllers.removeAt(row);
      regionControllers.removeAt(row);
      curveControllers.removeAt(row);
      bucketControllers.removeAt(row);
      callPutControllers.removeAt(row);
      strikeControllers.removeAt(row);
      priceAdjControllers.removeAt(row);
      volAdjControllers.removeAt(row);
      fixedPriceControllers.removeAt(row);
    }
  }

  List<Widget> header() {
    var _style = TextStyle(fontSize: 18, color: Theme.of(context).primaryColor);
    return [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.bottom,
          child: Container(
              margin: EdgeInsetsDirectional.only(end: _columnSpace),
              padding: EdgeInsetsDirectional.only(bottom: 4),
              child: Text('\nQuantity', style: _style))),
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
          child: Text(
            '\nCurve                   ', // 24 chars
            style: _style,
          ),
        ),
      ),
      Text('\nBucket   ', style: _style),
      Text('\nCall/Put', style: _style),
      Text('\nStrike', style: _style),
      Text('Fwd\nPrice', style: _style),
      Text('Price\nAdj', style: _style),
      Text('Vol\nAdj', style: _style),
      Text('Fix\nPrice   ', style: _style),
      Text('\nPrice', style: _style),
      Text(''),
    ];
  }

  // other details
  // final _backgroundColor = Colors.grey[300];
  final _columnSpace = 12.0;
  final _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.zero),
    borderSide: BorderSide(color: Colors.grey[300], width: 1),
  );
  final _errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  );
  final _rowSpacer =
      TableRow(children: List.generate(12, (index) => SizedBox(height: 4)));

  InputDecoration _getDecoration(String errorText) {
    return InputDecoration(
        errorText: errorText,
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        errorBorder: _errorBorder,
        focusedErrorBorder: _errorBorder,
        border: _outlineInputBorder,
        enabledBorder: _outlineInputBorder);
  }
}
