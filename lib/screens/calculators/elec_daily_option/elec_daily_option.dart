library screens.calculators.elec_daily_option;

import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:maya/models/asofdate_model.dart';
import 'package:maya/models/buysell_model.dart';
import 'package:maya/models/new/calculator_model/elec_daily_option.dart';
import 'package:maya/models/term_model.dart';
import 'package:maya/screens/calculators/asofdate.dart';
import 'package:maya/screens/calculators/buysell.dart';
import 'package:maya/screens/calculators/save_calculator.dart';
import 'leg_rows.dart';
import 'package:maya/screens/calculators/term.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ElecDailyOptionUi extends StatefulWidget {
  ElecDailyOptionUi({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EdoState();
}

class _EdoState extends State<ElecDailyOptionUi> {
  _EdoState();

  final _formKey = GlobalKey<FormState>();
  static final NumberFormat _dollarPriceFmt =
      NumberFormat.simpleCurrency(decimalDigits: 0, name: '');

  late TextEditingController _commentsController;

  @override
  void initState() {
    super.initState();
    final calculator = context.read<CalculatorModel>();
    final asOfDateModel = context.read<AsOfDateModel>();
    final termModel = context.read<TermModel>();
    final buySellModel = context.read<BuySellModel>();
    asOfDateModel.init(calculator.asOfDate);
    termModel.init(calculator.term);
    buySellModel.value = calculator.buySell;

    _commentsController = TextEditingController();
    _commentsController.text = calculator.calculator.comments;
  }

  @override
  Widget build(BuildContext context) {
    final calculator = context.watch<CalculatorModel>();
    final asOfDateModel = context.watch<AsOfDateModel>();
    final termModel = context.watch<TermModel>();
    final buySellModel = context.watch<BuySellModel>();

    return Form(
      key: _formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: 20),

        /// First row: Term, As of date, Buy/Sell widgets
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            TermUi(),
            SizedBox(width: 40),
            AsOfDateUi(),
            SizedBox(width: 40),
            BuySellUi(),
          ],
        ),

        /// Leg rows
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: LegRows(),
        ),
        const SizedBox(height: 20),

        /// Dollar price
        Row(children: [
          const SizedBox(width: 20),
          Text(
            'Dollar Price',
            style:
                TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 20),
          ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 100,
                minHeight: 37,
              ),
              child: Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.centerRight,
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorLight),
                child: FutureBuilder<String>(
                    future:
                        _dollarReprice(termModel, asOfDateModel, buySellModel),
                    builder: (context, snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = [
                          // Icon(Icons.done, color: Colors.green),
                          // SizedBox(width: 20),
                          Text(
                            snapshot.data!,
                            style: TextStyle(fontSize: 16),
                            key: Key('_edo_dollarPrice'),
                          )
                        ];
                      } else if (snapshot.hasError) {
                        children = [
                          Icon(Icons.error_outline, color: Colors.red),
                          Text(
                            snapshot.error.toString(),
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
                      return Row(children: children);
                    }),
              )),
        ]),
        const SizedBox(height: 20),

        /// Comments box
        Row(
          children: [
            Container(
              color: Colors.grey[300],
              margin: EdgeInsetsDirectional.only(start: 20),
              width: 500,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLength: null,
                maxLines: null,
                controller: _commentsController,
                decoration: InputDecoration(
                    labelText: 'Comments',
                    border: _outlineInputBorder,
                    enabledBorder: _outlineInputBorder,
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Enter a comment'),
              ),
            )
          ],
        ),
        const SizedBox(height: 40),

        /// Bottom app buttons (Details, Reports, Save, Help)
        Row(
          children: [
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _showDetails(context, calculator),
              child: Text('Details', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _showReports(context, calculator),
              child: Text('Reports', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _saveCalculator(context, calculator),
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              child: Text('Help', style: TextStyle(color: Colors.black)),
            ),
          ],
        )
      ]),
    );
  }

  Future<String> _dollarReprice(TermModel termModel,
      AsOfDateModel asOfDateModel, BuySellModel buySellModel) async {
    var calculator = context.read<CalculatorModel>();
    var value = '?';
    try {
      calculator.asOfDate = asOfDateModel.asOfDate;
      calculator.term = termModel.term;
      calculator.buySell = buySellModel.buySell;
      await calculator.build();
      var aux = calculator.dollarPrice();
      value = _dollarPriceFmt.format(aux);
    } catch (e) {
      print(e);
    }
    print(value);
    return value;
  }

  Future<void> _showDetails(BuildContext context, CalculatorModel model) async {
    var out = model.calculator.showDetails();
    await showDialog<Widget>(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SelectableText(
                    out,
                    style: GoogleFonts.inconsolata(fontSize: 16),
                  ),
                )
              ],
            ));
  }

  Future<void> _showReports(
      BuildContext context, CalculatorModel calculator) async {
    var child = SimpleDialog(
      title: Text('Report list'),
      children: [
        _ReportItem(
            icon: Icons.shuffle,
            color: Colors.blue,
            text: 'Delta Gamma report'),
        _ReportItem(
            icon: Icons.change_history,
            color: Colors.red,
            text: 'Monthly position report'),
        _ReportItem(
            icon: Icons.attach_money, color: Colors.green, text: 'PnL report'),
      ],
    );

    final value = await showDialog<String>(
      context: context,
      builder: (context) => child,
    );
    // The value passed to Navigator.pop() or null.
    if (value != null) {
      var out = calculator.reports[value].toString();
      await showDialog<Widget>(
          context: context,
          builder: (context) => SimpleDialog(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SelectableText(
                      out,
                      style: GoogleFonts.inconsolata(fontSize: 16),
                    ),
                  )
                ],
              ));
    }
  }

  Future<void> _saveCalculator(
      BuildContext context, CalculatorModel calculator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      calculator.calculator.comments = _commentsController.text;
      var json = calculator.calculator.toJson();
      await showDialog<void>(
        context: context,
        builder: (context) => SimpleDialog(children: [SaveCalculator(json)]),
      );
    }
  }

  final _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.zero),
    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
  );
}

class _ReportItem extends StatelessWidget {
  const _ReportItem(
      {Key? key, required this.icon, required this.color, required this.text})
      : super(key: key);

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.headline6;
    return SimpleDialogOption(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(text);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          Flexible(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Text(
                text,
                style: textTheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
