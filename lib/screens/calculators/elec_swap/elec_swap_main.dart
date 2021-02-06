library screens.calculators.elec_swap_main;

import 'package:flutter/material.dart';
import 'package:maya/models/asofdate_model.dart';
import 'package:maya/models/new/calculator_model/elec_swap.dart';
import 'package:maya/models/term_model.dart';
import 'package:maya/screens/calculators/elec_swap/elec_swap.dart';
import 'package:provider/provider.dart';

class ElecSwapMainUi extends StatelessWidget {
  ElecSwapMainUi({this.initialValue, Key key}) : super(key: key);

  final Map<String, dynamic> initialValue;
  final String title = 'Electricity swap calculator';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TermModel()),
          ChangeNotifierProvider(create: (context) => AsOfDateModel()),
          ChangeNotifierProvider(
              create: (context) => CalculatorModel()..init()),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElecSwapCalculatorUi(initialValue),
              ],
            ),
          ),
        ));
  }
}
