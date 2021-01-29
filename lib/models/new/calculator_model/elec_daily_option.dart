library model.new_.calculator_model.elec_daily_option;

import 'package:elec/calculators.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:date/date.dart';
import 'package:elec/calculators/elec_daily_option.dart';
import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:elec/src/risk_system/pricing/reports/report.dart';
import 'package:timeseries/timeseries.dart';

class CalculatorModel extends ChangeNotifier {
  // CalculatorModel can't extend ElecDailyOption.  I've tried and it
  // didn't draw the widgets.  Got a Maximum call stack size exceeded.
  ElecDailyOption _calculator;

  CalculatorModel() {
    init(); // don't need to do it here
  }

  /// From a mongo document.
  CalculatorModel.fromJson(Map<String, dynamic> x) {
    if (x['calculatorType'] == 'elec_daily_option') {
      _calculator = ElecDailyOption.fromJson(x);
    } else {
      throw ArgumentError('Not supported yet!');
    }
  }

  set asOfDate(Date asOfDate) {
    _calculator.asOfDate = asOfDate;
    notifyListeners();
  }

  Date get asOfDate => _calculator.asOfDate;

  set term(Term term) {
    _calculator.term = term;
    notifyListeners();
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

  /// set the quantity for this leg from a number
  void setFixPrice(int i, num value) {
    var months = term.interval.splitLeft((dt) => Month.fromTZDateTime(dt));
    _calculator.legs[i].fixPrice = TimeSeries.fill(months, value);
    notifyListeners();
  }

  /// set the quantity for this leg from a number
  void setQuantity(int i, num value) {
    var months = term.interval.splitLeft((dt) => Month.fromTZDateTime(dt));
    _calculator.legs[i].quantity = TimeSeries.fill(months, value);
    notifyListeners();
  }

  /// set the vol Adjustment for this leg
  void setPriceAdjustment(int i, num value) {
    var months = term.interval.splitLeft((dt) => Month.fromTZDateTime(dt));
    _calculator.legs[i].priceAdjustment = TimeSeries.fill(months, value);
    notifyListeners();
  }

  /// set the strike for this leg
  void setStrike(int i, num value) {
    var months = term.interval.splitLeft((dt) => Month.fromTZDateTime(dt));
    _calculator.legs[i].strike = TimeSeries.fill(months, value);
    notifyListeners();
  }

  /// set the vol Adjustment for this leg.  The value is in percent!
  void setVolAdjustment(int i, num value) {
    var months = term.interval.splitLeft((dt) => Month.fromTZDateTime(dt));
    _calculator.legs[i].volatilityAdjustment =
        TimeSeries.fill(months, value / 100);
    notifyListeners();
  }

  List<CommodityLeg> get legs => _calculator.legs;

  Future<void> build() => _calculator.build();

  num dollarPrice() => _calculator.dollarPrice();

  /// What reports are available to run on this calculator
  Map<String, Report> get reports => {
        'Delta Gamma report': _calculator.deltaGammaReport(),
        'Monthly position report': _calculator.monthlyPositionReport(),
        'PnL report': _calculator.flatReport(),
      };

  ElecDailyOption get calculator => _calculator;

  void init() {
    _calculator = ElecDailyOption.fromJson({
      'calculatorType': 'elec_daily_option',
      'term': 'Jan21-Feb21',
      'asOfDate': '2020-07-06',
      'buy/sell': 'Buy',
      'comments': 'a daily options calculator',
      'legs': [
        {
          'curveId': 'isone_energy_4000_da_lmp',
          'tzLocation': 'America/New_York', // ideally this should not be here
          'bucket': '5x16',
          'quantity': {'value': 50},
          'call/put': 'call',
          'strike': {'value': 100.0},
        }
      ],
    })
      ..cacheProvider = CacheProvider.test(
          client: Client(), rootUrl: DotEnv().env['rootUrl']);
  }
}
