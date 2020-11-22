library screens.calculators.elec_swap;

import 'package:date/date.dart';
import 'package:elec/elec.dart';
import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maya/screens/calculators/as_of_date.dart';
import 'package:maya/screens/calculators/elec_swap/leg_rows.dart';
import 'package:maya/screens/calculators/term.dart';
import 'package:timezone/timezone.dart';
import 'package:http/http.dart';
import 'package:elec/calculators/elec_swap.dart';
import 'package:elec/src/time/hourly_schedule.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:elec/src/risk_system/pricing/calculators/base/cache_provider.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final calcProvider = StateProvider((_) => ElecSwapCalculator());

class ElecSwapCalculatorUi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ElecSwapCalculatorState();
}

class _ElecSwapCalculatorState extends State<ElecSwapCalculatorUi> {
  _ElecSwapCalculatorState() {
    var rootUrl = DotEnv().env['rootUrl'];
    cacheProvider = CacheProvider.test(client: Client(), rootUrl: rootUrl);
    calculator = ElecSwapCalculator()
      ..cacheProvider = cacheProvider
      ..term = Term.parse('Jan21-Jun21', UTC)
      ..asOfDate = Date(2020, 5, 29)
      ..buySell = BuySell.buy
      ..legs = [
        CommodityLeg(
            curveId: 'isone_energy_4000_da_lmp',
            tzLocation: getLocation('America/New_York'),
            bucket: Bucket.b5x16,
            timePeriod: TimePeriod.month,
            quantitySchedule: HourlySchedule.filled(50)),
      ];
  }

  ElecSwapCalculator calculator;
  CacheProvider cacheProvider;

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  static final NumberFormat _dollarPriceFmt =
      NumberFormat.simpleCurrency(decimalDigits: 0, name: '');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            TermUi(calculator),
            SizedBox(width: 40),
            AsOfDateUi(calculator),
            SizedBox(width: 40),
            AdvancedSwitch(
              activeLabel: 'Buy',
              inactiveLabel: 'Sell',
              activeColor: Colors.green,
              inactiveColor: Colors.red,
              borderRadius: BorderRadius.circular(20),
              width: 100,
              height: 30,
              value: calculator.buySell == BuySell.buy ? true : false,
              onChanged: (value) => setState(() {
                calculator.buySell = value ? BuySell.buy : BuySell.sell;
                print(calculator.buySell);
              }),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: LegRows(calculator),
        ),
        const SizedBox(height: 20),
        // Dollar price
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
                    future: _dollarReprice(),
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
        // comments
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
        // Bottom app buttons
        Row(
          children: [
            const SizedBox(width: 20),
            RaisedButton(
                child: Text('Details'),
                onPressed: () => _showDetails(context),
                color: Theme.of(context).buttonColor),
            const SizedBox(width: 12),
            RaisedButton(
                child: Text('Reports'),
                onPressed: () => _showReports(context),
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
    );
  }

  Future<String> _dollarReprice() async {
    var value = '?';
    try {
      print('fix price: ${calculator.legs[0].showFixPrice()}');
      await calculator.build();
      var aux = calculator.dollarPrice();
      value = _dollarPriceFmt.format(aux);
    } catch (e) {
      print(e);
    }
    return value;
  }

  Future<void> _showDetails(BuildContext context) async {}

  Future<void> _showReports(BuildContext context) async {
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
      var line = 'You selected report: $value';
      var out = List.generate(50, (index) => line).join('\n');
      await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                title: Text(value),
                children: [SelectableText(out)],
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
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

// List<Widget> _getTableHeader() {
//   var _style = TextStyle(fontSize: 18, color: Theme.of(context).primaryColor);
//   var _columnSpace = 12.0;
//   var _boxDecoration = BoxDecoration(
//       border: Border(bottom: BorderSide(color: Colors.black26)));
//
//   return [
//     Text('Hourly\nQuantity   ', style: _style),
//     TableCell(
//       verticalAlignment: TableCellVerticalAlignment.bottom,
//       child: Container(
//         margin: EdgeInsetsDirectional.only(end: _columnSpace),
//         padding: EdgeInsetsDirectional.only(bottom: 4),
//         child: Text(
//           'Region',
//           style: _style,
//         ),
//         decoration: _boxDecoration,
//       ),
//     ),
//     TableCell(
//         verticalAlignment: TableCellVerticalAlignment.bottom,
//         child: Text('Service   ', style: _style)),
//     TableCell(
//       verticalAlignment: TableCellVerticalAlignment.bottom,
//       child: Container(
//         margin: EdgeInsetsDirectional.only(end: _columnSpace),
//         padding: EdgeInsetsDirectional.only(bottom: 4),
//         child: Text(
//           '\nCurve                   ', // 24 chars
//           style: _style,
//         ),
//         decoration: _boxDecoration,
//       ),
//     ),
//     // Text('\nCurve', style: _style),
//     Text('\nBucket   ', style: _style),
//     Text('Fixed\nPrice   ', style: _style),
//     Text('\nPrice   ', style: _style),
//     Text(''),
//   ];
// }
