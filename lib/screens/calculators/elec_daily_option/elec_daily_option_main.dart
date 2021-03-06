library screens.calculators.elec_daily_option_main;

import 'package:flutter/material.dart';
import 'package:maya/models/asofdate_model.dart';
import 'package:maya/models/buysell_model.dart';
import 'package:maya/models/new/calculator_model/elec_daily_option.dart';
import 'package:maya/models/term_model.dart';
import 'package:maya/screens/calculators/elec_daily_option/elec_daily_option.dart';
import 'package:provider/provider.dart';

// This widget is needed to collect all the providers needed for this calculator
class ElecDailyOptionMainUi extends StatelessWidget {
  ElecDailyOptionMainUi({required this.initialValue, Key? key})
      : super(key: key);

  final String title = 'Electricity daily option calculator';
  final Map<String, dynamic> initialValue;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TermModel()),
          ChangeNotifierProvider(create: (context) => AsOfDateModel()),
          ChangeNotifierProvider(create: (context) => BuySellModel()),
          ChangeNotifierProvider(
              create: (context) => CalculatorModel.fromJson(initialValue)),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElecDailyOptionUi(),
              ],
            ),
          ),
        ));
  }
}
