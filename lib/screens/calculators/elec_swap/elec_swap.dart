library screens.calculators.elec_swap;

import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maya/models/new/calculator_model.dart';
import 'package:maya/screens/calculators/as_of_date.dart';
import 'package:maya/screens/calculators/elec_swap/leg_rows.dart';
import 'package:maya/screens/calculators/term.dart';
import 'package:elec/calculators/elec_swap.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ElecSwapCalculatorUi extends StatelessWidget {
  ElecSwapCalculatorUi({Key key, this.title}) : super(key: key);

  final String title;

  final _formKey = GlobalKey<FormState>();
  static final NumberFormat _dollarPriceFmt =
      NumberFormat.simpleCurrency(decimalDigits: 0, name: '');

  @override
  Widget build(BuildContext context) {
    final calculator = context.watch<CalculatorModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    AdvancedSwitch(
                      activeChild: Text('Buy'),
                      inactiveChild: Text('Sell'),
                      activeColor: Colors.green,
                      inactiveColor: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      width: 100,
                      height: 30,
                      value: calculator.buySell == BuySell.buy ? true : false,
                      onChanged: (value) {
                        calculator.buySell = value ? BuySell.buy : BuySell.sell;
                      },
                    )
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
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).primaryColor),
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
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight),
                        child: FutureBuilder<String>(
                            future: _dollarReprice(calculator),
                            builder: (context, snapshot) {
                              List<Widget> children;
                              if (snapshot.hasData) {
                                children = [
                                  // Icon(Icons.done, color: Colors.green),
                                  // SizedBox(width: 20),
                                  Text(
                                    snapshot.data,
                                    style: TextStyle(fontSize: 16),
                                  )
                                ];
                              } else if (snapshot.hasError) {
                                children = [
                                  Icon(Icons.error_outline, color: Colors.red),
                                  Text(
                                    snapshot.error,
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
                      // height: 100,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLength: null,
                        maxLines: null,
                        decoration: InputDecoration(
                            labelText: 'Comments',
                            // labelStyle:
                            //     TextStyle(color: Theme.of(context).primaryColor),
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
                    RaisedButton(
                        child: Text('Details'),
                        onPressed: () => _showDetails(context, calculator),
                        color: Theme.of(context).buttonColor),
                    const SizedBox(width: 12),
                    RaisedButton(
                        child: Text('Reports'),
                        onPressed: () => _showReports(context, calculator),
                        color: Theme.of(context).buttonColor),
                    const SizedBox(width: 12),
                    RaisedButton(
                        child: Text('Save'),
                        onPressed: () {},
                        color: Theme.of(context).buttonColor),
                    const SizedBox(width: 12),
                    RaisedButton(
                        child: Text('Help'),
                        onPressed: () {},
                        color: Theme.of(context).buttonColor),
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future<String> _dollarReprice(CalculatorModel calculator) async {
    var value = '?';
    try {
      await calculator.build();
      var aux = calculator.dollarPrice();
      value = _dollarPriceFmt.format(aux);
    } catch (e) {
      print(e);
    }
    return value;
  }

  Future<void> _showDetails(BuildContext context, CalculatorModel model) async {
    var out = model.calculator.showDetails();
    await showDialog(
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
            icon: Icons.arrow_drop_up,
            color: Colors.red,
            text: 'Monthly position report'),
        _ReportItem(
            icon: Icons.attach_money, color: Colors.green, text: 'PnL report'),
      ],
    );

    final value = await showDialog(
      context: context,
      builder: (context) => child,
    );
    // The value passed to Navigator.pop() or null.
    if (value != null && value is String) {
      var out = calculator.reports[value].toString();
      await showDialog(
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

  final _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.zero),
    borderSide: BorderSide(color: Colors.grey[300], width: 1),
  );
}

class _ReportItem extends StatelessWidget {
  const _ReportItem({Key key, this.icon, this.color, this.text})
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
