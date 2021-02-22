library screens.homepage.calculator_list;

import 'package:flutter/material.dart';
import 'package:maya/models/new/calculator_list.dart';

class CalculatorList extends StatefulWidget {
  CalculatorList({Key key}) : super(key: key);
  @override
  _CalculatorListState createState() => _CalculatorListState();
}

class _CalculatorListState extends State<CalculatorList> {
  _CalculatorListState();

  int _hoveringIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        width: 400,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: List.generate(calculators.length, (index) {
            return MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _hoveringIndex = index;
                  });
                },
                onExit: (_) {
                  setState(() {
                    _hoveringIndex = null;
                  });
                },
                child: ListTile(
                  key: Key(calculatorTypes[index]),
                  onTap: () => _onReportTap(context, index),
                  onLongPress: () => _onReportTap(context, index),
                  selected: calculators[index].selected,
                  leading: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onReportTap(context, index),
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: calculators[index].color,
                        child: _hoveringIndex == index
                            ? Icon(
                                Icons.arrow_forward,
                                color: Colors.black26,
                              )
                            : null,
                      ),
                    ),
                  ),
                  title: Text(calculators[index].title),
                  // subtitle: Text(paints[index].title),
                ));
          }),
        ));
  }

  void _onReportTap(BuildContext context, int calculatorId) {
    Navigator.pushNamed(context, '/calculators',
        arguments: {'calculatorType': calculatorTypes[calculatorId]});
  }

  final Map<int, String> calculatorTypes = {
    0: 'elec_swap',
    1: 'elec_monthly_option',
    2: 'elec_daily_option',
    3: 'elec_heatrate_swap',
    4: 'elec_heatrate_option',
  };
}
