library models.buysell_model;

import 'package:date/date.dart';
import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

class BuySellModel extends ChangeNotifier {
  BuySellModel();

  late BuySell _buySell;

  set value(BuySell buySell) {
    _buySell = buySell;
  }

  void setAndNotify(BuySell buySell) {
    _buySell = buySell;
    notifyListeners();
  }

  BuySell get buySell => _buySell;
}
