library model.new_.calculator_model.elec_swap;

import 'package:elec/calculators.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:date/date.dart';
import 'package:elec/calculators/elec_swap.dart';
import 'package:elec/elec.dart';
import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';
import 'package:elec/src/risk_system/pricing/reports/report.dart';
import 'package:elec/src/time/hourly_schedule.dart';

class CalculatorModel extends ChangeNotifier {
  // CalculatorModel can't extend ElecSwapCalculator.  I've tried and it
  // didn't draw the widgets.  Got a Maximum call stack size exceeded.
  ElecSwapCalculator _calculator;

  CalculatorModel() {
    init(); // don't need to do it here
  }

  /// From a mongo document.
  CalculatorModel.fromJson(Map<String, dynamic> x) {
    if (x['calculatorType'] == 'elec_swap') {
      _calculator = ElecSwapCalculator.fromJson(x);
    } else {
      throw ArgumentError('Not supported yet!');
    }
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
    notifyListeners();
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

  void init() {
    _calculator = ElecSwapCalculator()
      ..cacheProvider =
          CacheProvider.test(client: Client(), rootUrl: DotEnv().env['rootUrl'])
      ..term = Term.parse('Jul21-Aug21', UTC)
      ..asOfDate = Date.today()
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
}
