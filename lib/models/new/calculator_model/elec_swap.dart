library model.new_.calculator_model.elec_swap;

import 'package:elec/calculators.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:date/date.dart';
import 'package:elec/calculators/elec_swap.dart';
import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:elec/src/risk_system/pricing/reports/report.dart';

class CalculatorModel extends ChangeNotifier {
  // CalculatorModel can't extend ElecSwapCalculator.  I've tried and it
  // didn't draw the widgets.  Got a Maximum call stack size exceeded.
  late ElecSwapCalculator _calculator;

  /// From a mongo document
  CalculatorModel.fromJson(Map<String, dynamic> x) {
    if (x.isEmpty) x = initialValue;
    if (x['calculatorType'] == 'elec_swap') {
      _calculator = ElecSwapCalculator.fromJson(x);
    } else {
      throw ArgumentError('Not supported yet!');
    }
    _calculator.cacheProvider =
        CacheProvider.test(client: Client(), rootUrl: dotenv.env['rootUrl']!);
  }

  set asOfDate(Date asOfDate) {
    _calculator.asOfDate = asOfDate;
  }

  Date get asOfDate => _calculator.asOfDate;

  set term(Term term) {
    _calculator.term = term;
  }

  Term get term => _calculator.term;

  set buySell(BuySell buySell) {
    _calculator.buySell = buySell;
  }

  BuySell get buySell => _calculator.buySell;

  void addLeg(int i, CommodityLeg leg) {
    _calculator.legs.insert(i, leg);
    notifyListeners();
  }

  void removeLeg(int i) {
    _calculator.legs.removeAt(i);
    notifyListeners();
  }

  void setLeg(int i, CommodityLeg leg) {
    _calculator.legs[i] = leg;
    notifyListeners();
  }

  List<CommodityLeg> get legs => _calculator.legs;

  Future<void> build() => _calculator.build();

  num dollarPrice() => _calculator.dollarPrice();

  /// What reports are available to run on this calculator
  Map<String, Report> get reports => {
        'Monthly position report': _calculator.monthlyPositionReport(),
        'PnL report': _calculator.flatReport(),
      };

  ElecSwapCalculator get calculator => _calculator;

  static final initialValue = <String, dynamic>{
    'calculatorType': 'elec_swap',
    'term': 'Jul21-Aug21',
    'buy/sell': 'Buy',
    'comments': '',
    'legs': [
      {
        'curveId': 'isone_energy_4000_da_lmp',
        'tzLocation': 'America/New_York',
        'bucket': '5x16',
        'quantity': {
          'value': 50,
        },
      }
    ],
  };
}
