library screens.homepage.calculator_list;

import 'package:flutter/material.dart';
import 'package:maya/models/calculator_list.dart';
import 'package:maya/main.dart';

class CalculatorList extends StatefulWidget {
  CalculatorList({Key key}) : super(key: key);
  @override
  _CalculatorListState createState() => _CalculatorListState();
}

class _CalculatorListState extends State<CalculatorList> {
  _CalculatorListState();
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      padding: EdgeInsets.all(20.0),
      children: List.generate(calculators.length, (index) {
        return ListTile(
          onTap: () => _onReportTap(context, index),
          selected: calculators[index].selected,
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: calculators[index].color,
              ),
            ),
          ),
          title: Text(calculators[index].title),
          // subtitle: Text(paints[index].title),
        );
      }),
    ));
  }

  void _onReportTap(BuildContext context, int calculatorId) {
    Navigator.pushNamed(context, reportsRoute,
        arguments: {'calculatorId': calculatorId});
  }
}
