library models.edit_quantity;

import 'package:flutter/material.dart';
import 'package:timeseries/timeseries.dart';

class EditQuantityModel extends ChangeNotifier {
  EditQuantityModel();

  late TimeSeries<num> _ts;

  void init(TimeSeries<num> x) => _ts = TimeSeries.fromIterable(x);

  set value(TimeSeries<num> x) {
    _ts = TimeSeries.fromIterable(x);
    notifyListeners();
  }

  TimeSeries<num> get value => _ts;
}
